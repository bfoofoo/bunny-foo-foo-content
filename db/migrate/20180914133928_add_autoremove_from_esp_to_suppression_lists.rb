class AddAutoremoveFromEspToSuppressionLists < ActiveRecord::Migration[5.0]
  def change
    add_column :suppression_lists, :autoremove_from_esp, :boolean, null: false, default: false
  end
end
