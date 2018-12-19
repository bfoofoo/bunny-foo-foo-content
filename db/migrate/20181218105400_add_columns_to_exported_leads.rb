class AddColumnsToExportedLeads < ActiveRecord::Migration[5.0]
  def change
    change_table :exported_leads do |t|
      t.string :autoresponse_message_id
      t.datetime :clicked_at
      t.datetime :opened_at
      t.datetime :followed_up_at
    end
  end
end
