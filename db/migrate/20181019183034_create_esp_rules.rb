class CreateEspRules < ActiveRecord::Migration[5.0]
  def change
    create_table :esp_rules do |t|
      t.references :source, polymorphic: true
      t.integer :delay_in_hours, null: false, default: 0
      t.string :domain
      t.string :affiliate
      t.timestamps
    end
  end
end
