module Statistics
  class FormsitesStatistics < Statistics::BaseStatistic

    def converted_counts_hash
      return @converted_counts_hash if !@converted_counts_hash.blank? 
      response = {}
      formsites.each do |formsite|
        response[formsite.name] = {
          formsite: formsite,
          total: filtered_users_by_affiliate(formsite, skip_converted: true).count,
          submitted: filtered_users_by_affiliate(formsite).count,
          total_converted: filtered_users_by_affiliate(formsite).select {|user| user.is_verified}.count,
          failed_impressionwise: filtered_users_by_affiliate(formsite).select {|user| !user.is_impressionwise_test_success}.count,
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
        response[:q][:created_at_gteq] = start_date.to_datetime.beginning_of_day
        response[:q][:created_at_lteq] = end_date.to_datetime.beginning_of_day
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

    def count_by_s
      return @count_by_s if !@count_by_s.blank?
      @count_by_s = 
        if formsite_selected?
          single_form_statistic
        else
          total_statistic
        end
    end

    def count_by_s_charts
      response = {
        name: "Users Count",
        colorByPoint: true,
        data: []
      }
      response[:data] = count_by_s.sort.to_h.map do |key, value| 
        [key, value]
      end
      return [response]
    end
    
    private 
    def total_statistic
      hash = {}
      formsites.each do |site|
        hash = fill_total_counter_hash(site, hash)
      end
      return hash
    end

    def single_form_statistic
      fields = all_fields - AFFILIATE_FIELDS
      hash = Hash[ fields.collect { |field| [field, 0] } ]
      fill_single_counter_hash({})
    end

    def fill_single_counter_hash hash
      formsite_users(formsite).each do |user|
        all_fields.each do |field|
          valid = !user[field].blank?
          valid = valid && a_fields_filter.include?(user["affiliate"]) if !a_fields_filter.blank?
          if valid
            counter_field = AFFILIATE_FIELDS.include?(field) ? user[field] : field
            hash[counter_field] = counter_hash_value(counter_field, hash) + 1
          end
        end
      end
      return hash
    end

    def fill_total_counter_hash site, hash
      formsite_users(site).each do |user|
        all_fields.each do |field|
          valid = !user[field].blank?
          valid = valid && a_fields_filter.include?(user["affiliate"]) if !a_fields_filter.blank?
          if valid
            counter_field = user[field]
            hash[counter_field] = counter_hash_value(counter_field, hash) + 1
          end
        end
      end
      return hash
    end

    def formsite_users site
      if @site != site
        @site = site
        @formsite_users = if !start_date.blank? && !end_date.blank?
          site.formsite_users.between_dates(start_date.to_datetime.beginning_of_day, end_date.to_datetime.end_of_day)
        else
          site.formsite_users
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
        users = users.where(is_duplicate: false)
      end
      
      if skip_converted
        users
      else
        users.select {|user| !user.user_id.blank?}
      end
    end 

    def counter_hash_value field, hash
      hash[field] || 0
    end
      
    def site_description_field site, field
      site["#{field}_description"]
    end
  end
end