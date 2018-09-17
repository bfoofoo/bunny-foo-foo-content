class RenameSuppresionLists < ActiveRecord::Migration[5.0]
  def up
    rename_table :suppresion_lists, :suppression_lists
  end

  def down
    rename_table :suppression_lists, :suppresion_lists
  end
end
