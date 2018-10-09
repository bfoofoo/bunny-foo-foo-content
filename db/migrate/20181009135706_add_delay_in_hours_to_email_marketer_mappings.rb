class AddDelayInHoursToEmailMarketerMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :email_marketer_mappings, :delay_in_hours, :integer
  end
end
