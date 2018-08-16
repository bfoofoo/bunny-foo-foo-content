class ChangeAStatField < ActiveRecord::Migration[5.0]
  def change
    rename_column :formsite_users, :a_stat, :affiliate
  end
end
