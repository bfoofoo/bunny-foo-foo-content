class CreateCustomFields < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_fields do |t|
      t.string :name, null: false
      t.string :values, array: true, null: false, default: []
      t.datetime :deleted_at
    end
  end
end
