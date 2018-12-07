class AddWebsiteIdToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :website_id, :integer
    add_index :formsite_users, :website_id
  end
end
