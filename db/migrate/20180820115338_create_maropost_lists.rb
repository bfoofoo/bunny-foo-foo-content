class CreateMaropostLists < ActiveRecord::Migration[5.0]
  def change
    create_table :maropost_lists do |t|
      t.references :maropost_account, foreign_key: true, null: false
      t.integer :list_id, null: false

      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
