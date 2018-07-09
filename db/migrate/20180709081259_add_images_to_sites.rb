class AddImagesToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :favicon_image, :string
    add_column :formsites, :logo_image, :string
    add_column :websites, :favicon_image, :string
    add_column :websites, :logo_image, :string
  end
end
