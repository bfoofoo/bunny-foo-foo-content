class CreateSparkpostAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :sparkpost_accounts do |t|
      t.integer :account_id
      t.string :username
      t.string :api_key, null: false

      t.timestamps null: false
    end
  end
end
