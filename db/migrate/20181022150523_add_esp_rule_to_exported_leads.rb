class AddEspRuleToExportedLeads < ActiveRecord::Migration[5.0]
  def change
    add_reference :exported_leads, :esp_rule, foreign_key: true
  end
end
