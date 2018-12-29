class RemoveBackgroundFromLeadgenEntries < ActiveRecord::Migration[5.0]
  def change
    remove_column :leadgen_entries, :background
  end
end
