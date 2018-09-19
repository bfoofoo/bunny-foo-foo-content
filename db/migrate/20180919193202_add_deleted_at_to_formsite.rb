class AddDeletedAtToFormsite < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :deleted_at, :datetime
    add_index :formsites, :deleted_at
  end
end
