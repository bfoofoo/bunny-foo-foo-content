class AddSiteTypeToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :site_type, :string, default: "leadgen"
  end
end
