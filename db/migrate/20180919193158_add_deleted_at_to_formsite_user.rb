class AddDeletedAtToFormsiteUser < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :deleted_at, :datetime
    add_index :formsite_users, :deleted_at
  end
end
