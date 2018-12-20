class AddReferenceToPrelanderSiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :prelander_site_users, :prelander_site, foreign_key: true
    add_reference :prelander_site_users, :user, foreign_key: true
  end
end
