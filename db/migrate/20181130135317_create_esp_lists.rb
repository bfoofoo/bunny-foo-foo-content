class CreateEspLists < ActiveRecord::Migration[5.0]
  def change
    create_table :esp_lists do |t|
      t.integer :account_id, null: false
      t.string :type, null: false
      t.bigint :list_id
      t.string :slug
      t.string :address
      t.string :name

      t.timestamps
    end
  end
end
