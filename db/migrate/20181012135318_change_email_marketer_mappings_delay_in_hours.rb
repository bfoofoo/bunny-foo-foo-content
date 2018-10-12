class ChangeEmailMarketerMappingsDelayInHours < ActiveRecord::Migration[5.0]
  def change
    change_column_default :email_marketer_mappings, :delay_in_hours, 0
  end
end
