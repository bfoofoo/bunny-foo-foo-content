class AddTextFileToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :text_file, :string
  end
end
