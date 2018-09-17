class AddCollectStatisticsToAweberLists < ActiveRecord::Migration[5.0]
  def change
    add_column :aweber_lists, :collect_statistics, :boolean, null: false, default: false
  end
end
