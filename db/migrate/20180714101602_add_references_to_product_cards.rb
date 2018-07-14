class AddReferencesToProductCards < ActiveRecord::Migration[5.0]
  def change
    add_reference :product_cards, :website, foreign_key: true
  end
end
