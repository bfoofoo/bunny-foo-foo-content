class ChangePrelanderSiteDropletIpType < ActiveRecord::Migration[5.0]
  def change
    change_column :prelander_sites, :droplet_ip, :string
  end
end
