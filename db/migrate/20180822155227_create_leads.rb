class CreateLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :leads do |t|
      t.string :type
      t.string :email
      t.string :full_name
      t.json :details, null: false, default: {}
      t.datetime :converted_at

      t.timestamps null: false
    end
  end
end
