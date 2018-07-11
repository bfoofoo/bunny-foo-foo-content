class AddFieldsToFormsite < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :is_thankyou, :boolean
    add_column :formsites, :background, :string
    add_column :formsites, :left_side_content, :text
  end
end
