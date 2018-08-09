module Statistics
  module Questions
    class AStatistics < Statistics::Questions::BaseStatistics

      def answers_counter_a_charts
        total_chart_statistics(DEFAULT_CHART_RESPONSE)
      end

      private 
      def answers_count answer, field
        filtered_formsite_user_answers(answer).select {|user_answer| 
          user_answer.answer_id ==  answer.id && !user_answer.formsite_user["affiliate"].blank? && field == user_answer.formsite_user["affiliate"]
        }.count
      end

      def type_fields
        FormsiteUser.where.not(affiliate: nil).pluck(:affiliate).uniq
      end
      
    end
  end
end