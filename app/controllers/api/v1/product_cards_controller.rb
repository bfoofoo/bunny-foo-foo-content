class Api::V1::ProductCardsController < ApiController
  before_action :set_product_card, only: [:show]

  def index
    product_cards = ProductCard.all.order('created_at DESC')
    if params[:leadgen_rev_site_id]
      query = product_cards.joins(:product_cards_leadgen_rev_sites).where(product_cards_leadgen_rev_sites: {leadgen_rev_site_id: params[:leadgen_rev_site_id]})
      return render json: paginate_items(query)
    end
    render json: product_cards
  end

  private

  def set_product_card
    @product_card = ProductCard.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }
  end
end
