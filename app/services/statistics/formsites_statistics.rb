module Statistics
  class FormsitesStatistics < Statistics::BaseStatistic
    def initialize(params={})
      super
      @start_date ||= Time.zone.yesterday
      @end_date ||= Time.zone.yesterday
    end

    def converted_counts_hash
      return @converted_counts_hash if !@converted_counts_hash.blank? 
      response = {}
      formsites.each do |formsite|
        response[formsite.name] = {
          formsite: formsite,
          total: filtered_users_by_affiliate(formsite, skip_converted: true, skip_duplicated: false).count,
          submitted: filtered_users_by_affiliate(formsite, skip_duplicated: false).count,
          total_converted: filtered_users_by_affiliate(formsite).select {|user| user.is_verified}.count,
          failed_impressionwise: filtered_users_by_affiliate(formsite, skip_converted: false).select {|user| !user.is_impressionwise_test_success}.count,
          failed_useragent: filtered_users_by_affiliate(formsite).select {|user| !user.is_useragent_valid}.count,
          failed_dulpicate: filtered_users_by_affiliate(formsite, skip_duplicated: false).select {|user| user.is_duplicate}.count
        }
      end
      @converted_counts_hash = response
      return @converted_counts_hash
    end

    def query_params_hash(stats, custom_hash={})
      response =  {
        q: {
          formsite_id_eq: stats[:formsite], 
          is_duplicate_eq: false
        }
      }

      if !start_date.blank? && !end_date.blank?
        response[:q][:created_at_gteq_datetime] = start_date.to_date.beginning_of_day
        response[:q][:created_at_lteq_datetime] = end_date.to_date.beginning_of_day
      end

      if !a_fields_filter.blank?
        response[:q][:affiliate_matches_any] = a_fields_filter
      end

      if !s_fields_filter.blank?
        s_fields_filter.each do |s_field| 
          response[:q]["#{s_field}_blank".to_sym] = false
        end
      end

      response[:q] = response[:q].merge(custom_hash) if !custom_hash.blank?

      return response
    end
    
    private
    def formsite_users site
      if @site != site
        @site = site
        @formsite_users = if !start_date.blank? && !end_date.blank?
          site.formsite_users.without_test_users.between_dates(start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
        else
          site.formsite_users.without_test_users
        end
      else
        return @formsite_users
      end
    end

    def filtered_users_by_affiliate site, skip_converted:false, skip_duplicated: true
      users = if a_fields_filter.blank? && s_fields_filter.blank?
        formsite_users(site)
      else
        formsite_users(site).select do |user|
          response = true
          if !a_fields_filter.blank?
            response = response && a_fields_filter.include?(user["affiliate"])
          end

          if !s_fields_filter.blank?
            response = response && s_fields_filter.map {|field| !user[field].blank? }.any?
          end

          response
        end
      end

      if skip_duplicated
        users = users.select {|user| user.is_duplicate.blank?}
      end
      
      if skip_converted
        users
      else
        users.select {|user| !user.user_id.blank?}
      end
    end 
    
  end
end
