class CreateOnepointLists < ActiveRecord::Migration[5.0]
  def change
    create_table :onepoint_lists do |t|
      t.references :onepoint_account, null: false, foreign_key: true
      t.integer :list_id, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
