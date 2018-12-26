class Api::V1::PrelanderSitesQuestionsController < ApplicationController
    before_action :set_prelander_site, only: [:index, :create_answer]
    before_action :set_question, only: [:create_answer]
    before_action :set_prelander_site_user, only: [:create_answer]
  
    def index
      @questions = @prelander_site.questions.order_by_position.includes(:answers)
      render json: @questions
    end
  
    def create_answer
      answer = @question.prelander_site_user_answers.build(answer_params.merge({prelander_site_user_id: @prelander_site_user.id, prelander_site_id: @prelander_site.id}))
      if answer.save
        render json: answer
      else
        render json: {message: answer.errors}, status: 422
      end
    end
  
    private
  
    def answer_params
      params.require(:answer).permit(:question_id, :answer_id, :url)
    end
  
    def set_prelander_site_user
      @prelander_site_user = PrelanderSiteUser.find_by!(ip: request.env['REMOTE_ADDR'], prelander_site_id: @prelander_site.id)
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: e.message}
    end
  
    def set_prelander_site
      @prelander_site = PrelanderSite.find(params[:prelander_site_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: e.message}
    end
  
    def set_question
      @question = Question.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: e.message}
    end
  end
  