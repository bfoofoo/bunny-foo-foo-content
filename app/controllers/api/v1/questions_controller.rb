class Api::V1::QuestionsController < ApiController
  before_action :set_question, only: [:show]

  def index
    questions = Question.all.order('created_at DESC')
    if params[:leadgen_rev_site_id]
      query = questions.where(leadgen_rev_site_id: params[:leadgen_rev_site_id])
      return render json: paginate_items(query)
    end
    render json: questions
  end

  def show
    render json: @question
  end

  private

  def set_question
    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }
  end
end
