module Statistics
  module EmailMarketers
    class BaseGraphStats
      attr_reader :start_date, :end_date

      def initialize(params = {})
        @start_date = Date.parse(params[:start_date]) rescue nil || 1.week.ago.at_beginning_of_week.to_date
        @end_date = Date.parse(params[:end_date]) rescue nil || 1.week.ago.at_end_of_week.to_date
        @leads_by_types = {}
      end

      def chart_data
        {
          categories: categories,
          series: series
        }
      end

      private

      def lead_class
        raise NotImplementedError
      end

      def account_class
        raise NotImplementedError
      end

      def account_id
        nil
      end

      def account
        account_class.find_by(id: account_id)
      end

      def categories
        all_affiliates.map do |affiliate|
          {
            name: affiliate_name(affiliate)
          }
        end
      end

      def series
        types_of_leads.map do |type|
          {
            name: type,
            data: leads_list_by_type(type)
          }
        end
      end

      def leads_list_by_type(type)
        grouped_leads = leads_by_type(type)
        leads_count_by_affiliates(grouped_leads)
      end

      def leads_by_type(type)
        return @leads_by_types[type] if @leads_by_types[type]
        query = lead_class.where(status: type)
        query = query.by_account_id(account.account_id) if account
        query = query.where('leads.event_at > ?', start_date.beginning_of_day) if start_date
        query = query.where('leads.event_at < ?', end_date.end_of_day) if end_date
        @leads_by_types[type] = query.to_a.group_by(&:affiliate).each_with_object({}) { |(k, v), h| h[k] = v.map(&:email) }
      end

      def leads_count_by_affiliates(leads)
        all_affiliates.map do |affiliate|
          leads[affiliate] = leads[affiliate].nil? ? 0 : leads[affiliate].count
        end
      end

      def group_leads_by_affiliate(leads)
        leads.each_with_object({}) do |lead, memo|
          memo[lead.affiliate] = memo[lead.affiliate].nil? ? lead.count : memo[lead.affiliate] + lead.count
        end
      end

      def all_affiliates
        @all_affiliates ||= FormsiteUser.distinct(:affiliate).pluck(:affiliate).compact
      end

      def affiliate_name(affiliate)
        affiliate.nil? ? 'No affiliate' : "A=#{affiliate}"
      end

      def all_types
        types_of_leads
      end

      def types_of_leads
        %w(sent_message open click)
      end
    end
  end
end
