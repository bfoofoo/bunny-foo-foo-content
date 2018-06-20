class AddWebsiteToArticles < ActiveRecord::Migration[5.0]
  def change
    add_reference :articles, :website, foreign_key: true
  end
end
