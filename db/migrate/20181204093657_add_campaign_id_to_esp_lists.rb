class AddCampaignIdToEspLists < ActiveRecord::Migration[5.0]
  def change
    add_column :esp_lists, :campaign_id, :string
  end
end
