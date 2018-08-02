class AddNdmTokenToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :ndm_token, :string
  end
end
