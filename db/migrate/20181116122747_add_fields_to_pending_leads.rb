class AddFieldsToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :pending_leads, :user_id, :integer
    add_column :pending_leads, :destination_type, :string
  end
end
