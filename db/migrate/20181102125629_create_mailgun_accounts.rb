class CreateMailgunAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :mailgun_accounts do |t|
      t.string :api_key, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
