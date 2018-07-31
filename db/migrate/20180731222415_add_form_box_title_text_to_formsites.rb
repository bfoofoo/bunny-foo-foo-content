class AddFormBoxTitleTextToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :form_box_title_text, :string
  end
end
