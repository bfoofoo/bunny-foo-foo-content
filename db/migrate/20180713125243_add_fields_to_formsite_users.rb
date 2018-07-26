class AddFieldsToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :is_useragent_valid, :boolean
    add_column :formsite_users, :is_impressionwise_test_success, :boolean
  end
end
