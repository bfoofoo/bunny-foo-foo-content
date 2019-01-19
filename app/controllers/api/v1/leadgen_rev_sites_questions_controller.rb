class Api::V1::LeadgenRevSitesQuestionsController < ApplicationController
  before_action :set_leadgen_rev_site, only: [:index, :create_answer]
  before_action :set_question, only: [:create_answer]
  before_action :set_leadgen_rev_site_user, only: [:create_answer]

  def index
    @questions = @leadgen_rev_site.questions.order_by_position.not_for_prelander.includes(:answers)
    render json: @questions
  end

  def create_answer
    service = LeadgenRevSiteUserAnswer::CreateAnswerUseCase.new(@question, answer_params.merge(
      leadgen_rev_site_user_id: @leadgen_rev_site_user&.id,
      leadgen_rev_site_id: @leadgen_rev_site.id,
      ip: request.env['REMOTE_ADDR']
    ))
    if service.perform
      render json: service.lrsu_answer
    else
      render json: {message: service.lrsu_answer.errors}, status: 422
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :answer_id, :url, :email)
  end

  def set_leadgen_rev_site_user
    @leadgen_rev_site_user = LeadgenRevSiteUser.find_by(ip: request.env['REMOTE_ADDR'], leadgen_rev_site_id: @leadgen_rev_site.id)
  end

  def set_leadgen_rev_site
    @leadgen_rev_site = LeadgenRevSite.find(params[:leadgen_rev_site_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def set_question
    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end
end
