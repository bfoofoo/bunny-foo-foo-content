class AddNetworkLookupSuccessToLeadgenRevSiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_users, :network_lookup_success, :boolean, default: false
  end
end
