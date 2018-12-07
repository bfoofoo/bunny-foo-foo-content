class CreateProductCardsLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    create_table :product_cards_leadgen_rev_sites do |t|
      t.belongs_to :product_card
      t.belongs_to :leadgen_rev_site
      t.timestamps
    end
  end
end
