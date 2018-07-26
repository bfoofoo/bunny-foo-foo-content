class ChangeZoneIdType < ActiveRecord::Migration[5.0]
  def change
    change_column :websites, :zone_id, :string
    change_column :formsites, :zone_id, :string
  end
end
