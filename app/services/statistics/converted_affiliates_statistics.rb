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
        {:name=>"Total", :data=> get_stats_type(calculated_stats, :total) },
        {:name=>"Converted", :data=> get_stats_type(calculated_stats, :converted) }
      ]
    end

    def calculated_stats
      calc_response = {}
      date_range.map do |day|
        day = day.to_date
        users = grouped_users[day] || []
        calc_response = handle_count_response(day, calc_response)
        calc_response = fill_counters(users, calc_response, day)
      end
      calc_response
    end

    def fill_counters(users, calc_response, day)
      users.each do |user|
        response = user.created_at.beginning_of_day.to_date == day.to_date
        response = handle_converted_filter response, user

        if response
          calc_response[day][:total] = calc_response[day][:total] + 1
        end
        if response && !user.user_id.blank? && user.is_verified
          calc_response[day][:converted] = calc_response[day][:converted] + 1
        end
      end
      return calc_response
    end

    def get_stats_type stats, type
      stats.map {|date, stats| stats[type]}
    end

    def handle_count_response day, response={}
      response[day] ||= {}
      response[day][:total] ||= 0
      response[day][:converted] ||= 0
      return response
    end

    def handle_converted_filter status, user
      case converted_filter
        when "total"
          status
        when "only_affiliates"
          status && !user["affiliate"].blank?
        when "without_affiliates"
          status && user["affiliate"].blank?
        else
          status
      end
    end

    def formsite_users
      return @formsite_users if !@formsite_users.blank?
      @formsite_users = formsite.formsite_users.not_duplicate.between_dates(filter_start_date.beginning_of_day, filter_end_date.end_of_day)
    end

    def grouped_users
      return @grouped_users if !@grouped_users.blank?
      @grouped_users = formsite_users.group_by {|item| item.created_at.beginning_of_day.to_date }
    end

    def date_range
      (filter_start_date .. filter_end_date)
    end
  end
end