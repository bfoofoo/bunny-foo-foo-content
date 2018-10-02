class AddDeletedAtToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :deleted_at, :datetime
    add_index :websites, :deleted_at
  end
end
