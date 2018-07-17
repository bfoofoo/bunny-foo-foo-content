class AddDisqusFieldsToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :shortname, :string
  end
end
