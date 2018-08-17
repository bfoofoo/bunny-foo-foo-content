module Statistics
  class ConvertedAffiliatesStatistics < Statistics::BaseStatistic

    CONVERTED_FILTERS = [
      ["Total Converted", "total"],
      ["Only affiliates", "only_affiliates"],
      ["Without affiliates", "without_affiliates"],
    ]

    def chart_data
      hash = {
        categories: categories,
        series: series
      }
      return hash
    end

    def formsite
      return @formsite if !@formsite.blank?
      @formsite = 
        if !formsite_id.blank?
          Formsite.find_by_id(formsite_id)
        else
          formsites.first
        end
    end

    def filter_start_date
      (start_date || DateTime.now.beginning_of_week).to_datetime
    end
    
    def filter_end_date
      (end_date || DateTime.now.beginning_of_day).to_datetime
    end
    
    private 

    def categories
      date_range.map do |day|
        day.strftime("%F")
      end
    end

    def series 
      return [
        {:name=>"Total", :data=>total_users_data},
        {:name=>"Converted", :data=>converted_users_data}
      ]
    end

    def converted_users_data
      date_range.map do |day|
        formsite_users.select {|user| check_with_params(user, day) }.count
      end
    end

    def check_with_params user, day
      response = user.created_at.beginning_of_day.to_date == day.to_date && !user.user_id.blank?
      case converted_filter
        when "total"
          response
        when "only_affiliates"
          response && !user["affiliate"].blank?
        when "without_affiliates"
          response && user["affiliate"].blank?
        else
          response
      end
    end

    def total_users_data
      response =  []
      date_range.each do |day|
        response << formsite_users.select {|user| user.created_at.beginning_of_day.to_date == day.to_date }.count
      end
      response
    end

    def formsite_users
      @formsite_users ||= formsite.formsite_users.between_dates(filter_start_date.beginning_of_day, filter_end_date.end_of_day)
    end

    def formsite_users_hash
      return @formsite_users_hash if !@formsite_users_hash.blank?
      @formsite_users_hash = Hash[ formsite_users.collect { |user| [user.created_at.beginning_of_day, user] } ]
    end

    def date_range
      (filter_start_date .. filter_end_date)
    end
  end
end