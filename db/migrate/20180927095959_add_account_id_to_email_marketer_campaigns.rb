class AddAccountIdToEmailMarketerCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_marketer_campaigns, :account_id, :integer
  end
end
