class CreateMailgunLists < ActiveRecord::Migration[5.0]
  def change
    create_table :mailgun_lists do |t|
      t.string :name
      t.string :address
      t.references :mailgun_account, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
