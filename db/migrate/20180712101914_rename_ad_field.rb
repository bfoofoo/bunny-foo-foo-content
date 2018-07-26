class RenameAdField < ActiveRecord::Migration[5.0]
  def change
    remove_column :ads, :type, :string
    add_column :ads, :variety, :string
  end
end
