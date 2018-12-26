class AddDeletedAtToPrelander < ActiveRecord::Migration[5.0]
  def change
    add_column :prelander_sites, :deleted_at, :datetime
    add_index :prelander_sites, :deleted_at

    add_column :prelander_site_users, :deleted_at, :datetime
    add_index :prelander_site_users, :deleted_at
  end
end
