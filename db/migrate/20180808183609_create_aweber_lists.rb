class CreateAweberLists < ActiveRecord::Migration[5.0]
  def change
    create_table :aweber_lists do |t|
      t.integer :aweber_account_id
      t.string :name
      t.integer :list_id

      t.timestamps
    end
  end
end
