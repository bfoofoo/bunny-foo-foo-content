class CreateEspRulesLists < ActiveRecord::Migration[5.0]
  def change
    create_table :esp_rules_lists do |t|
      t.references :esp_rule, null: false, foreign_key: true
      t.references :list, polymorphic: true
    end
  end
end
