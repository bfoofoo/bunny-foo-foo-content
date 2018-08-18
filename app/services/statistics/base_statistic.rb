module Statistics
  class BaseStatistic
    attr_reader :formsites, :counter_hash, :start_date, :end_date, :formsite_id, :s_fields_filter, :a_fields_filter, :converted_filter

    S_FIELDS = ["s1", "s2", "s3", "s4", "s5"]
    AFFILIATE_FIELDS = ["affiliate"]

    def initialize(params={})
      @start_date = params[:start_date]
      @end_date = params[:end_date]

      @converted_filter = params[:converted_filter]
      @formsite_id = params[:formsite_id]
      @s_fields_filter = params[:s_fields_filter] || []
      @a_fields_filter = params[:a_fields_filter] || []
    end
    
    def all_fields
      S_FIELDS + AFFILIATE_FIELDS
    end

    def formsite
      return @formsite if !@formsite.blank?
      @formsite = Formsite.includes([:formsite_users]).find_by_id(formsite_id)
    end

    def available_affiliate_stats
      if formsite.blank?
        FormsiteUser.not_duplicate.all.pluck(:affiliate).uniq.compact
      else
        formsite.formsite_users.not_duplicate.pluck(:affiliate).uniq.compact
      end
    end
    
    private 
      def formsite_selected?
        !formsite.blank?
      end

      def questions
        return @questions if !@questions.blank?
        @questions = Question.includes(answers: [formsite_user_answers: [:formsite_user]]).order_by_position.all
      end

      def answers
        return @answers if !@answers.blank?
        @answers = Answer.includes([:question]).all.order_by_question_id
      end

      def filtered_answers
        return @filtered_answers if !@filtered_answers.blank?
        if formsite_selected?
          answers.select {|a| a.question.formsite_id == formsite_id.to_i}
        else
          answers
        end
      end
      
      def formsites
        return @formsites if !@formsites.blank?
        @formsites = Formsite.includes(:formsite_users).all
      end

      def filtered_s_fields
        return @filtered_s_fields if !@filtered_s_fields.blank?
        @filtered_s_fields = if s_fields_filter.blank?
          S_FIELDS
        else
          S_FIELDS & s_fields_filter
        end
      end

  end
end