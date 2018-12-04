class ChangeMailgunTemplatesSchedulesReferences < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :mailgun_templates_schedules, :mailgun_lists
    add_foreign_key :mailgun_templates_schedules, :esp_lists, column: :mailgun_list_id
  end
end
