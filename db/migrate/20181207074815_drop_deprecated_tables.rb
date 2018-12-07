class DropDeprecatedTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :email_marketer_campaigns
    drop_table :email_marketer_mappings
    drop_table :leads
    drop_table :aweber_rules
  end
end
