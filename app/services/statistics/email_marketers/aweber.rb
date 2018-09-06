module Statistics
  module EmailMarketers
    class Aweber
      attr_reader :aweber_list_id, :start_date, :end_date

      def initialize(params = {})
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @aweber_list_id = params[:aweber_list_id]
        @leads_by_types = {}
      end

      def affiliate_chart_data
        {
          categories: categories,
          series: series
        }
      end


      def aweber_list
        return @aweber_list if !@aweber_list.blank?
        @aweber_list =
          if !aweber_list_id.blank?
            AweberList.find_by(id: aweber_list_id)
          else
            aweber_lists.first
          end
      end

      private

      def aweber_lists
        return @aweber_lists if !@aweber_lists.blank?
        @aweber_lists = AweberList.all
      end

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
        query =
          FormsiteUser
            .select('COUNT(affiliate), affiliate')
            .joins(user: :aweber_list)
            .where.not(affiliate: nil)

        query = query.where(aweber_lists: { id: aweber_list_id }) if aweber_list.present?
        query = query.where('formsite_users.created_at > ?', start_date) if start_date
        query = query.where('formsite_users.created_at < ?', end_date) if end_date

        grouped_leads = query.group(:affiliate).to_a
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
        return @leads_by_types[type] if @leads_by_types[type]
        query =
          Leads::Aweber
            .select('COUNT(affiliate), affiliate')
            .joins(:source)
            .where(status: type)

        query = query.where(aweber_lists: { id: aweber_list_id }) if aweber_list.present?
        query = query.where('leads.date > ?', start_date) if start_date
        query = query.where('leads.date < ?', end_date) if end_date
        @leads_by_types[type] = query.group(:affiliate).to_a
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
