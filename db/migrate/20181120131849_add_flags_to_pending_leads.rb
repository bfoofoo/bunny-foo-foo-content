class AddFlagsToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :pending_leads, :sent_to_adopia, :boolean, default: false
    add_column :pending_leads, :sent_to_netatlantic, :boolean, default: false
    add_index :pending_leads, :sent_to_adopia
    add_index :pending_leads, :sent_to_netatlantic
  end
end
