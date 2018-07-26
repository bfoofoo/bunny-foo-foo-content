class AddConfigToFormsite < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :ad_client, :string
    add_column :formsites, :ad_sidebar_id, :string
    add_column :formsites, :ad_top_id, :string
    add_column :formsites, :ad_middle_id, :string
    add_column :formsites, :ad_bottom_id, :string
  end
end
