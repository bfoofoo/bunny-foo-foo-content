module Statistics
  module Questions
    class SStatistics < Statistics::Questions::BaseStatistics

      def answers_counter_s_charts
        total_chart_statistics(DEFAULT_CHART_RESPONSE)
      end

      private 
      def answers_count answer, field
        filtered_formsite_user_answers(answer).select {|user_answer| 
          response = user_answer.answer_id ==  answer.id && !user_answer.formsite_user.is_duplicate
          response = response && s_values_valid(user_answer, field)
          if !a_fields_filter.blank?
            response = response && a_fields_filter.include?(user_answer.formsite_user["affiliate"]) 
          end
          response
        }.count
      end

      def s_values_valid(user_answer, field)
        response = false
        S_FIELDS.each do |s_field|
          response = response || user_answer.formsite_user[s_field] == field
        end
        return response
      end

      def type_fields
        return @type_fields if !@type_fields.blank?
        @type_fields = formsite.formsite_users.map {|user| 
          s_fields_filter.map {|s_filter| user[s_filter]} 
        }.flatten.uniq.reject { |c| c.blank? }
      end
    end
  end
end