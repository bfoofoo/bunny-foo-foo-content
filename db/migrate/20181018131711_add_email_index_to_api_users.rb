class AddEmailIndexToApiUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :api_users, :email
  end
end
