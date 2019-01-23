class DropObsoleteColumnsFromExportedLeads < ActiveRecord::Migration[5.0]
  def change
    remove_column :exported_leads, :autoresponded_at
    remove_column :exported_leads, :autoresponse_message_id
    remove_column :exported_leads, :clicked_at
    remove_column :exported_leads, :opened_at
    remove_column :exported_leads, :followed_up_at
  end
end
