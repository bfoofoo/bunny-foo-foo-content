class AddIpToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :ip, :string
  end
end
