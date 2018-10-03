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
        category = day.strftime("%F")
        if converted_filter == "only_affiliates"
          category = {
            name: category,
            categories: affiliate_categories
          }
        end
        category
      end
    end

    def affiliate_categories
      a_fields_filter.blank? ? available_affiliate_stats : a_fields_filter
    end

    def series
      return [
        {:name=>"Total", :data=> get_stats_type(calculated_stats, :total) },
        {:name=>"Converted", :data=> get_stats_type(calculated_stats, :converted) }
      ]
    end

    def calculated_stats
      return @calculated_stats if !@calculated_stats.blank?
      calc_response = {}
      date_range.map do |day|
        day = day.to_date
        users = grouped_users[day] || []
        calc_response[day] ||= {}
        calc_response = fill_counters(users, calc_response, day)
      end
      @calculated_stats = calc_response
    end

    def fill_counters(users, calc_response, day)
      users.each do |user|
        response = user.created_at.beginning_of_day.to_date == day.to_date
        response = handle_converted_filter response, user
        if converted_filter == "only_affiliates"
          calc_response = affiliate_calcs(response, calc_response, day, user)
        else
          calc_response = total_stats_calc(response, calc_response, day, user)
        end
      end
      return calc_response
    end

    def affiliate_calcs(user_status, calc_response, day, user)
      affiliate_categories.each do |affiliate_category|
        user_valid = user_status && user["affiliate"] == affiliate_category

        calc_response[day][affiliate_category] ||= {}
        calc_response[day][affiliate_category][:total] ||= 0
        calc_response[day][affiliate_category][:converted] ||= 0

        calc_response[day][affiliate_category] = fill_day_counter(
          calc_response[day][affiliate_category],
          user,
          user_valid
        )

      end
      calc_response
    end

    def total_stats_calc(response, calc_response, day, user)
      calc_response[day][:total] ||= 0
      calc_response[day][:converted] ||= 0
      calc_response[day] = fill_day_counter(calc_response[day], user, response)
      calc_response
    end

    def fill_day_counter hash, user, user_valid
      if user_valid
        hash[:total] = hash[:total] + 1
      end
      if user_valid && !user.user_id.blank? && user.is_verified
        hash[:converted] = hash[:converted] + 1
      end
      hash
    end

    def get_stats_type stats, type
      stats.map {|date, stats| 
        if converted_filter == "only_affiliates"
          stats.map {|affiliate, stats| stats[type] }
        else
          stats[type]
        end
      }.flatten
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
      @formsite_users = formsite.formsite_users.without_test_users.not_duplicate.between_dates(filter_start_date.beginning_of_day, filter_end_date.end_of_day)
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