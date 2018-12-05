class ReplaceUsersUnsubscribedWithUnsubscribedAt < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :unsubscribed, :boolean, null: false, default: false
    add_column :users, :unsubscribed_at, :datetime
  end
end
