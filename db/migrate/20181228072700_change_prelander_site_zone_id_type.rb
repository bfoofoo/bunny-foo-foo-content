class ChangePrelanderSiteZoneIdType < ActiveRecord::Migration[5.0]
  def change
    change_column :prelander_sites, :zone_id, :string
  end
end
