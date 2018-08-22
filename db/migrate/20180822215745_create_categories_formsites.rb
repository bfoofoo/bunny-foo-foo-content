class CreateCategoriesFormsites < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_formsites do |t|
      t.integer :formsite_id
      t.integer :category_id
    end
  end
end
