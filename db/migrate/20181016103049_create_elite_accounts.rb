class CreateEliteAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :elite_accounts do |t|
      t.string :sender
      t.string :api_key, null: false
      t.timestamps
    end
  end
end
