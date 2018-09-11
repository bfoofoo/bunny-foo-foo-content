class ChangeLeadsDateColumn < ActiveRecord::Migration[5.0]
  def up
    change_column :leads, :date, :datetime
    rename_column :leads, :date, :event_at
  end

  def down
    rename_column :leads, :event_at, :date
    change_column :leads, :date, :date
  end
end
