class AddCustomFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :custom_fields, :hstore
  end
end
