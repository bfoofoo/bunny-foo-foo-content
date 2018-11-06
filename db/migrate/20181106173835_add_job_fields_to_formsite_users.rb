class AddJobFieldsToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :external_link, :string
    add_column :formsite_users, :company, :string
    add_column :formsite_users, :abstract, :string
    add_column :formsite_users, :title, :string
    add_column :formsite_users, :data_key, :string
  end
end
