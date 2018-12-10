class AddStateToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :state, :string
  end
end
