class AddConfigToWebsite < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :ad_client, :string
    add_column :websites, :ad_sidebar_id, :string
    add_column :websites, :ad_top_id, :string
    add_column :websites, :ad_middle_id, :string
    add_column :websites, :ad_bottom_id, :string
  end
end
