class AddAddedToAweberToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :added_to_aweber, :boolean, default: false
  end
end
