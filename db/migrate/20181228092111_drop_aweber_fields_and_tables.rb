class DropAweberFieldsAndTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :formsite_aweber_lists
    remove_column :users, :added_to_aweber
  end
end
