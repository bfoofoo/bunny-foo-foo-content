class CreateMaropostAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :maropost_accounts do |t|
      t.integer :account_id, null: false
      t.text :auth_token, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
