class AddDelayInHoursToFormsiteAweberLists < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_aweber_lists, :delay_in_hours, :integer, null: false, default: 0
  end
end
