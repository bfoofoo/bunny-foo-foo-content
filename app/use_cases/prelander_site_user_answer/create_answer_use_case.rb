class PrelanderSiteUserAnswer
  class CreateAnswerUseCase
    attr_reader :psu_answer

    def initialize(question, answer_params)
      @question = question
      @params = answer_params
    end

    def perform
      @psu_answer = @question.prelander_site_user_answers.build(@params)
      @psu_answer.save!
      key = @question.custom_field&.name
      if @question.custom_field_id && user && user.try(key).blank?
        user.update(key => answer.custom_field_value)
      end
      true
    rescue => e
      Rollbar.error(e)
      false
    end

    def user
      return @user if defined?(@user)
      psu = PrelanderSiteUser.find_by(id: @params[:prelander_site_user_id])
      return unless psu&.user_id
      @user = psu.user
    end

    def answer
      @answer ||= Answer.find_by(id: @params[:answer_id])
    end
  end
end
