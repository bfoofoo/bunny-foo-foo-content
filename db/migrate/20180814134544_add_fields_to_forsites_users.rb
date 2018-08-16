class AddFieldsToForsitesUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :birthday, :datetime
    add_column :formsite_users, :zip, :string
    add_column :formsite_users, :phone, :string
  end
end
