class AddColumnsToExportedLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :exported_leads, :clicked_at, :datetime
    add_column :exported_leads, :opened_at, :datetime
    add_column :exported_leads, :followed_up_at, :datetime
  end
end
