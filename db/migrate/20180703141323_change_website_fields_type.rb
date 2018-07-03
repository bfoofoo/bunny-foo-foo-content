class ChangeWebsiteFieldsType < ActiveRecord::Migration[5.0]
  def change
    change_column :websites, :droplet_ip, :string
  end
end
