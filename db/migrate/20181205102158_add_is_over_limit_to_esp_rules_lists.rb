class AddIsOverLimitToEspRulesLists < ActiveRecord::Migration[5.0]
  def change
    add_column :esp_rules_lists, :is_over_limit, :boolean, default: false
  end
end
