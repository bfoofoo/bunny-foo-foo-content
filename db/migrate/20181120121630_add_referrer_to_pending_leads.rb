class AddReferrerToPendingLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :pending_leads, :referrer, :text
  end
end
