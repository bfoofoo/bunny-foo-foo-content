class AddRepoUrlToFormsite < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :repo_url, :string
  end
end
