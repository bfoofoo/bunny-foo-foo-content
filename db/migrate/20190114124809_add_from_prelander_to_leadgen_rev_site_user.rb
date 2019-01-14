class AddFromPrelanderToLeadgenRevSiteUser < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_users, :from_prelander, :boolean
  end
end
