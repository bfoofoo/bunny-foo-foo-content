class AddMemberStatusToEspLists < ActiveRecord::Migration[5.0]
  def change
    add_column :esp_lists, :member_status, :string, default: 'normal'
  end
end
