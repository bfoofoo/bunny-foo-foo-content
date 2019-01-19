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
      @lrsu_answer.errors.add(:base, e.to_s)
      false
    end

    private

    def answer_params
      if @question.for_prelander?
        @params[:leadgen_rev_site_user_id] = find_leadrev_user_by_email&.id
      end
      @params.except(:ip)
    end

    def leadrev_user
      @leadrev_user ||= @question.for_prelander? ?
                          find_leadrev_user_by_email : LeadgenRevSiteUser.find_by(id: @params[:leadgen_rev_site_user_id])
    end

    def find_leadrev_user_by_email
      User
        .joins(:leadgen_rev_site_users)
        .where(email: @params[:email])
        .leadgen_rev_site_users
        &.where(leadgen_rev_site_id: @params[:leadgen_rev_site_id], is_verified: true)
        &.first
    end

    # TODO For prelander user identification, not currently in use
    def find_or_create_prelander_user
      @new_leadrev_user ||= LeadgenRevSiteUser.find_or_create_by(
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
