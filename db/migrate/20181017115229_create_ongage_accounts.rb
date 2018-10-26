class CreateOngageAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :ongage_accounts do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :account_code, null: false
      t.timestamps
    end
  end
end
