class CreateMailgunTemplatesSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :mailgun_templates_schedules do |t|
      t.references :mailgun_template, index: true, foreign_key: true, null: false
      t.references :mailgun_list, index: true, foreign_key: true, null: false
      t.datetime :sending_time, null: false
      t.string :scheduled_job_id

      t.timestamps
    end

    remove_reference :mailgun_templates, :mailgun_list, index: true, foreign_key: true
  end
end
