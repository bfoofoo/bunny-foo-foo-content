class AddIndexesToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_index :pending_leads, :referrer
    add_index :pending_leads, :destination_type
  end
end
