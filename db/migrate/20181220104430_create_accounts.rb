class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :type
      t.string :name
      t.string :api_key
      t.hstore :params

      t.timestamps
    end
  end
end
