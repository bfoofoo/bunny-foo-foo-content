class AffFileNameToSuppressionLists < ActiveRecord::Migration[5.0]
  def change
    add_column :suppresion_lists, :file_name, :string
  end
end
