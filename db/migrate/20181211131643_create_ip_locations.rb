class CreateIpLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_locations do |t|
      t.bigint :ip_from
      t.bigint :ip_to
      t.string :country_code, limit: 2
      t.string :country_name, limit: 64
      t.string :region_name, limit: 128
      t.string :city_name, limit: 128
    end
    add_index :ip_locations, [:ip_from, :ip_to]
  end
end
