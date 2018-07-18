class ChangeRateFieldTypeOnProductCards < ActiveRecord::Migration[5.0]
  def change
    remove_column :product_cards, :rate, :integer
    add_column :product_cards, :rate, :float
  end
end
