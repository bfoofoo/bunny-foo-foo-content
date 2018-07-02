class RemoveWebsiteIdFromCategories < ActiveRecord::Migration[5.0]
  def change
    remove_column :categories, :website_id, :integer
  end
end
