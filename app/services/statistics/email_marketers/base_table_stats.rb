module Statistics
  module EmailMarketers
    class BaseTableStats
      attr_reader :start_date, :end_date

      HOURS_PER_CELL = 3

      def initialize(params = {})
        @start_date = Date.parse(params[:start_date]) rescue nil || Date.today.at_beginning_of_month
        @end_date = Date.parse(params[:end_date]) rescue nil || Date.today.at_end_of_month
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

      def list
        raise NotImplementedError
      end

      def list_id
        raise NotImplementedError
      end

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

      def total_users
        FormsiteUser.joins(user: list_element_name)
      end

      def group_all_leads
        @grouped_leads = {}
        types_of_leads.each do |type|
          @grouped_leads = @grouped_leads.deep_merge(grouped_leads_by_type(type))
        end

        query = FormsiteUser.joins(user: list_element_name).where.not(affiliate: nil)

        query = query.where(list_table_name => { id: list_id }) if list.present?
        query = query.where('formsite_users.created_at > ?', start_date) if start_date
        query = query.where('formsite_users.created_at < ?', end_date) if end_date

        @grouped_leads.deep_merge!(deep_group_leads(query.to_a, :created_at, 'total'))
        grouped_leads_sorted
      end

      # Group leads 4 levels deep (1 - day, 2 - hour, 3 - affiliate, 4 - status (event type))
      def deep_group_leads(leads, date_field, status)
        leads.group_by { |l| l.send(date_field).to_date }.each_with_object({}) do |(k, v), h|
          h[k] = v.sort_by(&date_field).group_by do |l|
            date = l.send(date_field)
            date.change(hour: date.hour / HOURS_PER_CELL * HOURS_PER_CELL)
          end.each_with_object({}) do |(k1, v1), h1|
            h1[k1] = v1.group_by(&:affiliate).each_with_object({}) do |(k2, v2), h2|
              h2[k2] = { status => v2.map(&:email).uniq.size }
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
        query = lead_class.joins(:source).where.not(affiliate: nil).where(status: type)
        table_name = list_class.table_name.to_sym

        query = query.where(table_name => { id: list_id }) if list.present?
        query = query.where('leads.event_at > ?', start_date.beginning_of_day) if start_date
        query = query.where('leads.event_at < ?', end_date.end_of_day) if end_date
        @leads_by_types[type] = query.to_a
      end

      def all_affiliates
        (FormsiteUser.pluck(:affiliate).uniq + lead_class.pluck(:affiliate).uniq).compact.uniq
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
        @types_of_leads ||= lead_class.pluck(:status).uniq
      end
    end
  end
end
