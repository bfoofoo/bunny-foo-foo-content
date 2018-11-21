class Api::V1::WebsitesQuestionsController < ApplicationController
    before_action :set_website, only: [:index, :create_answer]
    before_action :set_question, only: [:create_answer]
    before_action :set_formsite_user, only: [:create_answer]
  
    def index
      @questions = @website.questions.order_by_position.includes(:answers)
      render json: @questions
    end
  
    def create_answer
      answer = @question.website_user_answers.build(answer_params.merge({formsite_user_id: @formsite_user.id, formsite_id: @website.id}))
      if answer.save
        render json: answer
      else
        render json: {message: answer.errors}, status: 422
      end
    end
  
    private 
      def answer_params
        params.require(:answer).permit(:question_id, :answer_id)
      end
  
      def set_formsite_user
        @formsite_user = FormsiteUser.find_by!(ip: request.env['REMOTE_ADDR'], website_id: @website.id)
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}
      end
  
      def set_website
        @website = Website.find(params[:website_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}
      end
  
      def set_question
        @question = Question.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: e.message}
      end
  end
  