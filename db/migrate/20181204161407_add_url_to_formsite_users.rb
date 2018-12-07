class AddUrlToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :url, :string
  end
end
