class AddAccountNameToNetatlanticAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :netatlantic_accounts, :account_name, :string
  end
end
