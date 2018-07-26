class AddRightSideContentToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :right_side_content, :text
  end
end
