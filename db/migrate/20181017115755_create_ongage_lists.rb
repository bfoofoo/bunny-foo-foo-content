class CreateOngageLists < ActiveRecord::Migration[5.0]
  def change
    create_table :ongage_lists do |t|
      t.integer :list_id, null: false
      t.references :ongage_account, foreign_key: true, index: true, null: false
      t.string :name
      t.timestamps
    end
  end
end
