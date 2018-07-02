class AddFieldsToWebsite < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :droplet_id, :integer
    add_column :websites, :droplet_ip, :integer
    add_column :websites, :zone_id, :integer
  end
end
