class DropObsoleteTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :adopia_lists
    drop_table :adopia_accounts
    drop_table :elite_groups
    drop_table :elite_accounts
    drop_table :mailgun_lists
    drop_table :mailgun_accounts
    drop_table :netatlantic_lists
    drop_table :netatlantic_accounts
    drop_table :onepoint_lists
    drop_table :onepoint_accounts
    drop_table :sparkpost_lists
    drop_table :sparkpost_accounts
  end
end
