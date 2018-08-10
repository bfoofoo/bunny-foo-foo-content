class AddAStatToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :a_stat, :string
  end
end
