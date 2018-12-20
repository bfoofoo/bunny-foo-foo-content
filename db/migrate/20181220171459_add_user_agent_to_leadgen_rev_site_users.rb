class AddUserAgentToLeadgenRevSiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_users, :user_agent, :string
  end
end
