class AddTagToEmailMarketerMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :email_marketer_mappings, :tag, :string
  end
end
