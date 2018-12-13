class AddAutorespondedAtToExportedLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :exported_leads, :autoresponded_at, :datetime
  end
end
