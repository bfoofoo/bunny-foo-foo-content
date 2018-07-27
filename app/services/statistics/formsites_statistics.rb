module Statistics
  class FormsitesStatistics
    attr_reader :formsites, :counter_hash

    S_FIELDS = ["s1", "s2", "s3", "s4", "s5"]

    def initialize
      @counter_hash = {}
    end

    def count_by_s_description
      return @count_by_s_description if !@count_by_s_description.blank?
      formsites.each do |site|
        fill_counter_hash(site)
      end
      @count_by_s_description = @counter_hash
      return @counter_hash
    end

    private 
    def fill_counter_hash site
      site.formsite_users.each do |user|
        S_FIELDS.each do |field|
          if !user[field].blank?
            site_field = site_description_field site, field
            if !site_field.blank?
              @counter_hash[site_field] = counter_hash_vaue(site_field) + 1
            end
          end
        end
      end
    end

    def counter_hash_vaue field
      @counter_hash[field] || 0
    end

    def formsites
      return @formsites if !@formsites.blank?
      @formsites = Formsite.includes(:formsite_users).all
    end

    def site_description_field site, field
      site["#{field}_description"]
    end
  end
end