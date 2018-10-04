class AddIsEmailDuplicateToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :is_email_duplicate, :boolean, default: false
  end
end
