class CreateEspAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :esp_accounts do |t|
      t.string :type, null: false
      t.string :name
      t.text :api_key
      t.text :access_token
      t.text :secret_token
      t.text :oauth_token
      t.integer :account_id
      t.string :account_code
      t.string :username
      t.string :password
      t.integer :daily_limit, default: 0

      t.timestamps
    end
  end
end
