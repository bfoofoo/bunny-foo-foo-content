class AddParamsToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :s1, :string
    add_column :formsite_users, :s2, :string
    add_column :formsite_users, :s3, :string
  end
end
