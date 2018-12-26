class AddColumnsToProductCards < ActiveRecord::Migration[5.0]
  def change
    add_column :product_cards, :button_text, :string
    add_column :product_cards, :full_description, :text
  end
end
