module Statistics
  class FormsitesStatistics < Statistics::BaseStatistic
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
      if !start_date.blank? && !end_date.blank?
        site.formsite_users.between_dates(start_date, end_date)
      else
        site.formsite_users
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