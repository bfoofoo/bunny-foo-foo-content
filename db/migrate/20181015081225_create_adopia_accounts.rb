class CreateAdopiaAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :adopia_accounts do |t|
      t.string :name
      t.string :api_key

      t.timestamps null: false
    end
  end
end
