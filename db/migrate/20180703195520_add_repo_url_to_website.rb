class AddRepoUrlToWebsite < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :repo_url, :string
  end
end
