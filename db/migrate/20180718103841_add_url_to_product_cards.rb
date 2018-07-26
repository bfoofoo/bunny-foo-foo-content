class AddUrlToProductCards < ActiveRecord::Migration[5.0]
  def change
    add_column :product_cards, :url, :string
  end
end
