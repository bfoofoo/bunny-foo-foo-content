class AddQueryParamsToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :s4, :string
    add_column :formsite_users, :s5, :string
  end
end
