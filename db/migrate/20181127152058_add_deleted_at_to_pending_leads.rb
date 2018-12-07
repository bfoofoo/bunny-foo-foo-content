class AddDeletedAtToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :pending_leads, :deleted_at, :datetime
    add_index :pending_leads, :deleted_at
  end
end
