module Statistics
  module EmailMarketers
    class BaseTableStats
      attr_reader :start_date, :end_date

      def initialize(params = {})
        @start_date = Date.parse(params[:start_date]) rescue nil || Date.today.at_beginning_of_month
        @end_date = Date.parse(params[:end_date]) rescue nil || Date.today.at_end_of_month
        @leads_by_types = {}
        @campaigns = {}
      end

      def data
        {
          cells: group_all_leads,
          affiliates: all_affiliates,
          types: all_types,
          max_value: max_value
        }
      end

      private

      def lead_class
        raise NotImplementedError
      end

      def list_class
        raise NotImplementedError
      end

      def list_table_name
        list_class.table_name.to_sym
      end

      def list_element_name
        list_class.model_name.element.to_sym
      end

      def all_dates
        (start_date..end_date).to_a
      end

      def group_all_leads
        @grouped_leads = build_grouped_leads
        build_campaign_data
        fill_empty_days
        types_of_leads.each do |type|
          @grouped_leads = @grouped_leads.deep_merge(grouped_leads_by_type(type))
        end
        grouped_leads_sorted
      end

      # Group leads 4 levels deep (1 - day, 2 - campaign, 3 - affiliate, 4 - status (event type))
      def deep_group_leads(leads, status)
        leads_by_campaign = leads.group_by(&:campaign_id)
        @grouped_leads.each_with_object({}) do |(k, v), h| # iterate dates
          h[k] = v.each_with_object({}) do |(campaign_id, _), h1| # iterate campaigns
            next unless leads_by_campaign[campaign_id]
            leads_by_affiliate = leads_by_campaign[campaign_id].group_by(&:affiliate)
            h1[campaign_id] = {
              'affiliates' =>
                leads_by_affiliate.each_with_object({}) do |(k2, v2), h2|
                  h2[k2] = { status => v2.map(&:email).uniq.size }
                end
            }
          end
        end
      end

      def build_grouped_leads
        array = all_dates.map do |date|
          [date, {}]
        end
        array.to_h
      end

      def build_campaign_data
        campaigns.where('sent_at BETWEEN ? AND ?', start_date.beginning_of_day, end_date.end_of_day).each do |campaign|
          date = campaign.sent_at.to_date
          @grouped_leads[date][campaign.campaign_id] = {
            'subject' => campaign.subject,
            'affiliates' => {},
            'sent_at' => campaign.sent_at,
            'total' => {
              'sent_message' => campaign.stats['sent'],
              'click' => campaign.stats['clicks'],
              'open' => campaign.stats['opens']
            }
          }
        end
      end

      def fill_empty_days
        @grouped_leads.each do |date, by_date|
          if by_date.empty?
            @grouped_leads[date] = {
              nil => { 'sent_at' => date.beginning_of_day }
            }
          end
        end
      end

      def grouped_leads_sorted
        @grouped_leads.sort.each_with_object({}) do |(k, v), h|
          h[k] = v.sort
        end
      end

      def grouped_leads_by_type(type)
        leads = leads_by_type(type)
        deep_group_leads(leads, type)
      end

      def leads_by_type(type)
        return @leads_by_types[type] if @leads_by_types[type]
        query = lead_class.joins(:source).where(status: type)

        query = query.where('leads.event_at > ?', start_date.beginning_of_day) if start_date
        query = query.where('leads.event_at < ?', end_date.end_of_day) if end_date
        @leads_by_types[type] = query.to_a
      end

      # get maximum value to be found in any table cell
      def max_value
        value = 0
        @grouped_leads.each do |_, v| # iterate dates
          v.each do |_, v1| # iterate campaigns
            next if v1.empty?
            sum = v1.dig('total', 'sent_message')
            value = sum if sum.to_i > value
          end
        end
        value
      end

      def all_affiliates
        @all_affiliates ||= (FormsiteUser.pluck(:affiliate).uniq + lead_class.pluck(:affiliate).uniq).uniq.compact
      end

      def all_types
        types_of_leads
      end

      def types_of_leads
        %w(sent_message open click)
      end

      def campaign_sent_at(id)
        @campaigns[id]&.sent_at ||= campaigns.find_by(id: id).sent_at
      end

      def campaign_id_by_time(time)
        return @campaigns[time] if @campaigns[time]
        @campaigns[time] = campaigns.find_by(sent_at: time)&.id
      end

      def campaigns
        raise NotImplementedError
      end
    end
  end
end
