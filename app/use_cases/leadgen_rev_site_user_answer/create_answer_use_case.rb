class LeadgenRevSiteUserAnswer
  class CreateAnswerUseCase
    attr_reader :lrsu_answer

    def initialize(question, answer_params)
      @question = question
      @params = answer_params
    end

    def perform
      @lrsu_answer = @question.leadgen_rev_site_user_answers.build(@params)
      @lrsu_answer.save!
      key = @question.custom_field.name
      if @question.custom_field_id && user && user.try(key).blank?
        user.update(key => answer.custom_field_value)
      end
      true
    rescue
      false
    end

    def user
      return @user if defined?(@user)
      lrsu = LeadgenRevSiteUser.find_by(id: @params[:leadgen_rev_site_user_id])
      return unless lrsu&.user_id
      @user = lrsu.user
    end

    def answer
      @answer ||= Answer.find_by(id: @params[:answer_id])
    end
  end
end
