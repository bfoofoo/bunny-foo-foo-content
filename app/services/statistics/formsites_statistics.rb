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
      response[:data] = count_by_s.map do |key, value| 
        [key, value]
      end
      return [response]
    end

    
    private 
    
    def formsite_selected?
      !formsite.blank?
    end
    
    def formsite
      return @formsite if !@formsite.blank?
      @formsite = Formsite.find_by_id(formsite_id)
    end

    def formsites
      return @formsites if !@formsites.blank?
      @formsites = Formsite.includes(:formsite_users).all
    end

    def total_statistic
      hash = {}
      formsites.each do |site|
        hash = fill_total_counter_hash(site, hash)
      end
      return hash
    end

    def single_form_statistic
      hash = Hash[ S_FIELDS.collect { |field| [field, 0] } ]
      fill_single_counter_hash(hash)
    end


    def fill_single_counter_hash hash
      formsite_users(formsite).each do |user|
        S_FIELDS.each do |field|
          if !user[field].blank?
            hash[field] = counter_hash_value(field, hash) + 1
          end
        end
      end
      return hash
    end

    def fill_total_counter_hash site, hash
      formsite_users(site).each do |user|
        S_FIELDS.each do |field|
          if !user[field].blank?
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