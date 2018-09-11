module Statistics
  module EmailMarketers
    class AweberTableStats < BaseStats
      def initialize(params = {})
        @start_date = Date.parse(params[:start_date]) rescue nil || Date.today.at_beginning_of_month
        @end_date = Date.parse(params[:end_date]) rescue nil || Date.today.at_end_of_month
        @aweber_list_id = params[:aweber_list_id]
        @leads_by_types = {}
      end

      def data
        {
          cells: group_all_leads,
          affiliates: all_affiliates,
          types: all_types
        }
      end

      private

      def total_users
        FormsiteUser.joins(user: :aweber_list)
      end

      def group_all_leads
        @grouped_leads = {}
        types_of_leads.each do |type|
          @grouped_leads = @grouped_leads.deep_merge(grouped_leads_by_type(type))
        end

        query = FormsiteUser.joins(user: :aweber_list).where.not(affiliate: nil)

        query = query.where(aweber_lists: { id: aweber_list_id }) if aweber_list.present?
        query = query.where('formsite_users.created_at > ?', start_date) if start_date
        query = query.where('formsite_users.created_at < ?', end_date) if end_date

        @grouped_leads.deep_merge!(deep_group_leads(query.to_a, :created_at, 'total'))
        grouped_leads_sorted
      end

      # Group leads 4 levels deep (1 - day, 2 - hour, 3 - affiliate, 4 - status (event type))
      def deep_group_leads(leads, date_field, status)
        leads.group_by { |l| l.send(date_field).to_date }.each_with_object({}) do |(k, v), h|
          h[k] = v.sort_by(&date_field).group_by { |l| l.send(date_field).beginning_of_hour }.each_with_object({}) do |(k1, v1), h1|
            h1[k1] = v1.group_by(&:affiliate).each_with_object({}) do |(k2, v2), h2|
              h2[k2] = { status => v2.size }
            end
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
        deep_group_leads(leads, :event_at, type)
      end

      def leads_by_type(type)
        return @leads_by_types[type] if @leads_by_types[type]
        query = Leads::Aweber.joins(:source).where(status: type)

        query = query.where(aweber_lists: { id: aweber_list_id }) if aweber_list.present?
        query = query.where('leads.event_at > ?', start_date.beginning_of_day) if start_date
        query = query.where('leads.event_at < ?', end_date.end_of_day) if end_date
        @leads_by_types[type] = query.to_a
      end

      def all_affiliates
        (FormsiteUser.pluck(:affiliate).uniq + Leads::Aweber.pluck(:affiliate).uniq).compact.uniq
      end

      def affiliate_name(affiliate)
        "A#{affiliate}"
      end

      def all_types
        [
          'total',
          *types_of_leads
        ]
      end

      def types_of_leads
        @types_of_leads ||= Leads::Aweber.pluck(:status).uniq
      end
    end
  end
end
