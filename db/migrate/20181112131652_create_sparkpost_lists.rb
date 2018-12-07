class CreateSparkpostLists < ActiveRecord::Migration[5.0]
  def change
    create_table :sparkpost_lists do |t|
      t.references :sparkpost_account, foreign_key: true, null: false
      t.string :list_id, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
