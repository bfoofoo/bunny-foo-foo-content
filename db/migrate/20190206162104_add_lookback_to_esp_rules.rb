class AddLookbackToEspRules < ActiveRecord::Migration[5.0]
  def change
    add_column :esp_rules, :lookback, :boolean, default: false
  end
end
