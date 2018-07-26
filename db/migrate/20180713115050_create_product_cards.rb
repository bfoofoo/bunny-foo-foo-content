class CreateProductCards < ActiveRecord::Migration[5.0]
  def change
    create_table :product_cards do |t|
      t.string :title
      t.string :description
      t.string :image
      t.integer :rate

      t.timestamps
    end
  end
end
