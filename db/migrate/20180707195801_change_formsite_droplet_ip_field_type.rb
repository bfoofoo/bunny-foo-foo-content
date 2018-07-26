class ChangeFormsiteDropletIpFieldType < ActiveRecord::Migration[5.0]
  def change
    change_column :formsites, :droplet_ip, :string
  end
end
