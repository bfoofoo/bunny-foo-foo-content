module Statistics
  module EmailMarketers
    class Aweber

      def initialize(params = {})
        # TODO add params
        @leads_by_types = {}
      end

      def affiliate_chart_data
        {
          categories: categories,
          series: series
        }
      end

      private

      def total_users
        FormsiteUser.joins(user: :aweber_list)
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
        grouped_leads = FormsiteUser.select('COUNT(affiliate), affiliate').joins(user: :aweber_list).where.not(affiliate: nil).group(:affiliate).to_a
        types_of_leads.each do |type|
          grouped_leads += leads_by_type(type)
        end
        leads_count_by_affiliates(grouped_leads)
      end

      def leads_list_by_type(type)
        grouped_leads = leads_by_type(type)
        leads_count_by_affiliates(grouped_leads)
      end

      def leads_by_type(type)
        @leads_by_types[type] ||= Leads::Aweber.select('COUNT(affiliate), affiliate').where(status: type).group(:affiliate).to_a
      end

      def leads_count_by_affiliates(leads)
        all_affiliates.map do |affiliate|
          group_leads_by_affiliate(leads)[affiliate]
        end
      end

      def group_leads_by_affiliate(leads)
        leads.each_with_object({}) do |lead, memo|
          memo[lead.affiliate] = memo[lead.affiliate].nil? ? lead.count : memo[lead.affiliate] + lead.count
        end
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
