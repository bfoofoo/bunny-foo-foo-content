class AddDateToLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :leads, :date, :date
  end
end
