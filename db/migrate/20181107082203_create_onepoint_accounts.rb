class CreateOnepointAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :onepoint_accounts do |t|
      t.string :username, null: false
      t.string :api_key, null: false

      t.timestamps null: false
    end
  end
end
