class DeleteUrlToFromsites < ActiveRecord::Migration[5.0]
  def change
    remove_column :formsite_users, :url
  end
end
