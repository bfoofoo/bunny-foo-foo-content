class CreateMessageAutoResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :message_auto_responses do |t|
      t.references :message_template, index: true, foreign_key: true, null: false
      t.references :esp_list, polymorphic: true
      t.string :scheduled_job_id
      t.integer :delay_in_minutes, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
