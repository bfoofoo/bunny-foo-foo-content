class AddIdAddressToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :pending_leads, :ip_address, :string
  end
end
