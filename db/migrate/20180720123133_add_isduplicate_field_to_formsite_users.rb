class AddIsduplicateFieldToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :is_duplicate, :boolean
  end
end
