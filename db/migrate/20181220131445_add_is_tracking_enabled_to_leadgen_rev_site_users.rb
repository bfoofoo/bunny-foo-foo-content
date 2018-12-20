class AddIsTrackingEnabledToLeadgenRevSiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_users, :is_tracking_enabled, :boolean, default: false
  end
end
