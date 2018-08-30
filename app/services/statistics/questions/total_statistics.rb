module Statistics
  module Questions
    class TotalStatistics < Statistics::Questions::BaseStatistics

      def answers_counter_s_charts
        total_chart_statistics(DEFAULT_CHART_RESPONSE)
      end

      private 
      def answers_count answer
        filtered_formsite_user_answers(answer).select {|user_answer| 
          user_answer.answer_id == answer.id && !user_answer.formsite_user.blank? && !user_answer.formsite_user.is_duplicate
        }.count
      end

      def type_fields
        return @type_fields if !@type_fields.blank?
        @type_fields = []
      end
    end
  end
end