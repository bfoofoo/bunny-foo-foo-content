module Statistics
  class BaseStatistic
    attr_reader :formsites, :counter_hash, :start_date, :end_date, :formsite_id

    S_FIELDS = ["s1", "s2", "s3", "s4", "s5"]

    def initialize(params={})
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @formsite_id = params[:formsite_id]
    end

    private 
      def formsite_selected?
        !formsite.blank?
      end

      def questions
        return @questions if !@questions.blank?
        @questions = Question.includes(answers: [formsite_user_answers: [:formsite_user]]).all
      end

      def answers
        return @answers if !@answers.blank?
        @answers = Answer.all.order_by_question_id
      end
      
      def formsite
        return @formsite if !@formsite.blank?
        @formsite = Formsite.find_by_id(formsite_id)
      end

      def formsites
        return @formsites if !@formsites.blank?
        @formsites = Formsite.includes(:formsite_users).all
      end

  end
end