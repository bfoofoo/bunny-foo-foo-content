class CreateAweberAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :aweber_accounts do |t|
      t.integer :account_id
      t.string :access_token
      t.string :secret_token

      t.timestamps
    end
  end
end
