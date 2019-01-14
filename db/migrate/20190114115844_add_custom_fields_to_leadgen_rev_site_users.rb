class AddCustomFieldsToLeadgenRevSiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_users, :custom_fields, :hstore
  end
end
