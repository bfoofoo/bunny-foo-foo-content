class DropMailgunTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :mailgun_templates_schedules
    drop_table :mailgun_templates
  end
end
