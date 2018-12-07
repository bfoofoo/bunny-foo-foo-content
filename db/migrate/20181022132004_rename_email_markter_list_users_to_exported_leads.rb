class RenameEmailMarkterListUsersToExportedLeads < ActiveRecord::Migration[5.0]
  def change
    rename_table :email_marketer_list_users, :exported_leads
  end
end
