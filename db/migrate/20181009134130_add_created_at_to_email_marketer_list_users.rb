class AddCreatedAtToEmailMarketerListUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :email_marketer_list_users, :created_at, :datetime
  end
end
