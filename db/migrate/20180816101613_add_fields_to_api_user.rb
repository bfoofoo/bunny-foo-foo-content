class AddFieldsToApiUser < ActiveRecord::Migration[5.0]
  def change
    add_column :api_users, :ip, :string
    add_column :api_users, :captured, :datetime
    add_column :api_users, :lead_id, :string
    add_column :api_users, :zip, :string
    add_column :api_users, :state, :string
    add_column :api_users, :phone1, :string
    add_column :api_users, :job, :string
  end
end
