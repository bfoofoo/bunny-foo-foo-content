class AddCategoriesWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_websites, :id => false do |t|
      t.integer :category_id
      t.integer :website_id
    end
  end
end
