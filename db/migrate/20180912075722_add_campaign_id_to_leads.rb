class AddCampaignIdToLeads < ActiveRecord::Migration[5.0]
  def change
    add_column :leads, :campaign_id, :integer
  end
end
