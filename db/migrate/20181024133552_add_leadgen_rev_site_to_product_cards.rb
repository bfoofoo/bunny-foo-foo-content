class AddLeadgenRevSiteToProductCards < ActiveRecord::Migration[5.0]
  def change
    add_reference :product_cards, :leadgen_rev_site, foreign_key: true
  end
end
