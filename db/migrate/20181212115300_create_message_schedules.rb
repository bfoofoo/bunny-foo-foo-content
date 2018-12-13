class CreateMessageSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :message_schedules do |t|
      t.references :message_template, index: true, foreign_key: true, null: false
      t.references :esp_list, polymorphic: true
      t.datetime :time, null: false
      t.string :scheduled_job_id
      t.string :state, null: false,   default: 'pending'
      t.integer :time_span, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
