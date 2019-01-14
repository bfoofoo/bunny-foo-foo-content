class LeadgenRevSiteUserAnswer
  class CreateAnswerUseCase
    attr_reader :lrsu_answer

    def initialize(question, answer_params)
      @question = question
      @params = answer_params
    end

    def perform
      @lrsu_answer = @question.leadgen_rev_site_user_answers.build(answer_params)
      @lrsu_answer.save!
      key = @question.custom_field&.name
      if @question.custom_field_id && leadrev_user && leadrev_user.try(key).blank?
        leadrev_user.update(key => answer.custom_field_value)
      end
      true
    rescue => e
      Rollbar.error(e)
      false
    end

    private

    def answer_params
      @params[:leadgen_rev_site_user_id] ||= leadrev_user&.id
      @params.except(:ip)
    end

    def leadrev_user
      return @leadrev_user if defined?(@leadrev_user)
      @leadrev_user = LeadgenRevSiteUser.find_by(id: @params[:leadgen_rev_site_user_id])
      @leadrev_user = create_prelander_user if @leadrev_user.blank? && @question.for_prelander?
      @leadrev_user
    end

    def create_prelander_user
      LeadgenRevSiteUser.create(
        leadgen_rev_site_id: @params[:leadgen_rev_site_id],
        ip: @params[:ip],
        from_prelander: true
      )
    end

    def answer
      @answer ||= Answer.find_by(id: @params[:answer_id])
    end
  end
end
