class AddSourceAndDestinationToLeads < ActiveRecord::Migration[5.0]
  def change
    change_table :leads do |t|
      t.integer :source_id
      t.integer :destination_id
    end
  end
end
