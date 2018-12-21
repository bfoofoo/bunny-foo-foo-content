class AddColumnsToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :pending_leads, :ip_address, :string
    add_column :pending_leads, :joined_at, :datetime
  end
end
