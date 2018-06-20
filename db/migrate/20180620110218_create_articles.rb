class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.text :content
      t.text :short
      t.references :category, foreign_key: true
      t.string :slug
      t.string :cover_image

      t.timestamps
    end
  end
end
