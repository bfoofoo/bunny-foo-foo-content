class LeadgenRevSiteUser
  class MassCreateAnswersUseCase
    include ActiveModel::Validations

    attr_reader :errors, :leadrev_user, :params

    def initialize(leadrev_user, params)
      @leadrev_user = leadrev_user
      @params = params
    end

    def perform
      return unless leadrev_user
      create_leadrev_answers
      errors.blank? ? true : false
    end

    def create_leadrev_answers
      params.each do |_, item|
        id = item[:question_id].to_i
        ::LeadgenRevSiteUserAnswer::CreateAnswerUseCase.new(questions[id], answer_params_for(item)).perform
      end
    end

    private

    def questions
      return @questions if defined?(@questions)
      question_ids = params.map { |_, item| item[:question_id] }
      @questions = Question.where(id: question_ids).index_by(&:id)
    end

    def answer_params_for(item)
      item.slice(:answer_id, :url).merge(
        leadgen_rev_site_id: leadrev_user.leadgen_rev_site_id,
        leadgen_rev_site_user_id: leadrev_user&.id
      )
    end
  end
end
