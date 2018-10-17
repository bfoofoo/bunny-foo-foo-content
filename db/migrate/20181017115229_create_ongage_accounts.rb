class CreateOngageAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :ongage_accounts do |t|
      t.string :account_id, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.timestamps
    end
  end
end
