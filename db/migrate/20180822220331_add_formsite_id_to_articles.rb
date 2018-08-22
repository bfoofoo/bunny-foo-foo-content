class AddFormsiteIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :formsite_id, :integer
  end
end
