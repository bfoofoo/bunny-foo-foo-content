class AddColumnsToAccounts < ActiveRecord::Migration[5.0]
  def change
    change_table :accounts do |t|
      t.string :username
      t.string :password
    end
  end
end
