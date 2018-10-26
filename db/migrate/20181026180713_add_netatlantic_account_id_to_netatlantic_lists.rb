class AddNetatlanticAccountIdToNetatlanticLists < ActiveRecord::Migration[5.0]
  def change
    add_column :netatlantic_lists, :netatlantic_account_id, :integer
  end
end
