class AddJobKeyToFormsiteUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_users, :job_key, :string
  end
end
