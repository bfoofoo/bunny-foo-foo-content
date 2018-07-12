class RemoveAdFieldsFromWebsite < ActiveRecord::Migration[5.0]
  def change
    remove_column :websites, :ad_sidebar_id, :string
    remove_column :websites, :ad_top_id, :string
    remove_column :websites, :ad_bottom_id, :string
    remove_column :websites, :ad_middle_id, :string
  end
end
