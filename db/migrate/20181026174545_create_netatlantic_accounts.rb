class CreateNetatlanticAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :netatlantic_accounts do |t|
      t.string :sender
      t.string :sender_name

      t.timestamps
    end
  end
end
