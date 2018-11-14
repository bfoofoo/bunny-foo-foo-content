class CreatePendingLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :pending_leads do |t|
      t.references :source, polymorphic: true
      t.string :email
      t.string :full_name
      t.string :destination_name
      t.datetime :created_at
      t.datetime :sent_at
    end
  end
end
