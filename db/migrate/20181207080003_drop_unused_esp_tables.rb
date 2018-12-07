class DropUnusedEspTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :aweber_lists
    drop_table :maropost_lists
    drop_table :ongage_lists

    drop_table :aweber_accounts
    drop_table :maropost_accounts
    drop_table :ongage_accounts
  end
end
