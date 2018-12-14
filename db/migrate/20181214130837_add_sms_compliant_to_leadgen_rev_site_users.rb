class AddSmsCompliantToLeadgenRevSiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_users, :sms_compliant, :boolean, default: false
  end
end
