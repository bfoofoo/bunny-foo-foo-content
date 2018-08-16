module Statistics
  module Questions
    class SStatistics < Statistics::Questions::BaseStatistics

      def answers_counter_s_charts
        total_chart_statistics(DEFAULT_CHART_RESPONSE)
      end

      private 
      def answers_count answer, field
        filtered_formsite_user_answers(answer).select {|user_answer| 
          response = user_answer.answer_id ==  answer.id && !user_answer.formsite_user[field].blank?
          response = response && a_fields_filter.include?(user_answer.formsite_user["affiliate"]) if !a_fields_filter.blank?
          response
        }.count
      end

      def type_fields
        filtered_s_fields
      end
      
    end
  end
end