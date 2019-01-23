class CreateMessageEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :message_events do |t|
      t.string :event_type
      t.string :message_id
      t.references :exported_lead
      t.references :message_auto_response

      t.datetime :created_at
    end
  end
end
