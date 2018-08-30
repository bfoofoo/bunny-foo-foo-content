class AddFieldsToLeads < ActiveRecord::Migration[5.0]
  def change
    change_table :leads do |t|
      t.references :user, foreign_key: true
      t.string :status
      t.string :affiliate
    end
  end
end
