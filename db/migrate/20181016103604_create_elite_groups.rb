class CreateEliteGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :elite_groups do |t|
      t.references :elite_account, foreign_key: true, index: true, null: false
      t.string :name
      t.string :group_id
      t.timestamps
    end
  end
end
