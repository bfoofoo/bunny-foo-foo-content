class AddNameToAweberAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :aweber_accounts, :name, :string
  end
end
