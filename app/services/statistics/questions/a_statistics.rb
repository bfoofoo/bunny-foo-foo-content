module Statistics
  module Questions
    class AStatistics < Statistics::Questions::BaseStatistics

      def answers_counter_a_charts
        total_chart_statistics(DEFAULT_CHART_RESPONSE)
      end

      private 
      def answers_count answer, field
        filtered_formsite_user_answers(answer).select {|user_answer| 
          user_answer.answer_id ==  answer.id && !user_answer.formsite_user["affiliate"].blank? && field == user_answer.formsite_user["affiliate"] &&!user_answer.formsite_user.is_duplicate
        }.count
      end

      def type_fields
        return @type_fields if !@type_fields.blank?
        fields = formsite.formsite_users.where.not(affiliate: nil).pluck(:affiliate).uniq
        @type_fields = 
          if a_fields_filter.blank?
            fields
          else
            fields & a_fields_filter
          end 
      end

    end
  end
end