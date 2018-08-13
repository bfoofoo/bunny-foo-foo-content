class CreateAweberRules < ActiveRecord::Migration[5.0]
  def change
    create_table :aweber_rules do |t|
      t.integer :list_from_id
      t.integer :list_to_id
      t.string :time

      t.timestamps
    end
  end
end
