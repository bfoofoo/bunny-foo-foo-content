class CreateAdopiaLists < ActiveRecord::Migration[5.0]
  def change
    create_table :adopia_lists do |t|
      t.references :adopia_account, null: false, foreign_key: true, index: true
      t.integer :list_id, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
