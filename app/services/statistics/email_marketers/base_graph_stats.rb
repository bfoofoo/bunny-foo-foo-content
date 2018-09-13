module Statistics
  module EmailMarketers
    class BaseGraphStats
      attr_reader :start_date, :end_date

      def initialize(params = {})
        @start_date = Date.parse(params[:start_date]) rescue nil
        @end_date = Date.parse(params[:end_date]) rescue nil
        @leads_by_types = {}
      end

      def chart_data
        {
          categories: categories,
          series: series
        }
      end

      private

      def list
        raise NotImplementedError
      end

      def list_id
        raise NotImplementedError
      end

      def list_element_name
        raise NotImplementedError
      end

      def list_table_name
        raise NotImplementedError
      end

      def lead_class
        raise NotImplementedError
      end

      def total_users
        FormsiteUser.joins(user: list_element_name)
      end

      def categories
        all_affiliates.map do |affiliate|
          {
            name: affiliate_name(affiliate),
            categories: [all_types.first]
          }
        end
      end

      def series
        array = [{
                   name: 'total',
                   data: leads_total_list
                 }]
        array + types_of_leads.map do |type|
          {
            name: type,
            data: leads_list_by_type(type)
          }
        end
      end

      def leads_total_list
        query =
          FormsiteUser.joins(user: list_element_name).where.not(affiliate: nil)

        query = query.where(list_table_name => { id: list_id }) if list.present?
        query = query.where('formsite_users.created_at > ?', start_date.beginning_of_day) if start_date
        query = query.where('formsite_users.created_at < ?', end_date.end_of_day) if end_date

        grouped_leads = query.to_a.group_by(&:affiliate).each_with_object({}) { |(k, v), h| h[k] = v.map(&:email) }

        types_of_leads.each do |type|
          grouped_leads.deep_merge!(leads_by_type(type)) { |_, v1, v2| (v1 + v2).uniq }
        end
        leads_count_by_affiliates(grouped_leads)
      end

      def leads_list_by_type(type)
        grouped_leads = leads_by_type(type)
        leads_count_by_affiliates(grouped_leads)
      end

      def leads_by_type(type)
        return @leads_by_types[type] if @leads_by_types[type]
        query =
          lead_class.joins(:source).where(status: type)

        query = query.where(list_table_name => { id: list_id }) if list.present?
        query = query.where('leads.event_at > ?', start_date.beginning_of_day) if start_date
        query = query.where('leads.event_at < ?', end_date.end_of_day) if end_date
        @leads_by_types[type] = query.to_a.group_by(&:affiliate).each_with_object({}) { |(k, v), h| h[k] = v.map(&:email) }
      end

      def leads_count_by_affiliates(leads)
        all_affiliates.map do |affiliate|
          leads[affiliate] = leads[affiliate].nil? ? 0 : leads[affiliate].uniq.count
        end
      end

      def group_leads_by_affiliate(leads)
        leads.each_with_object({}) do |lead, memo|
          memo[lead.affiliate] = memo[lead.affiliate].nil? ? lead.count : memo[lead.affiliate] + lead.count
        end
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
        @types_of_leads ||= Leads::Aweber.pluck(:status).uniq
      end
    end
  end
end
