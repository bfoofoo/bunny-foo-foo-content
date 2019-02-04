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

    def answer
      @answer ||= Answer.find_by(id: @params[:answer_id])
    end
  end
end
