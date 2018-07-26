class AddIsCheckboxesToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :is_checkboxes, :boolean
  end
end
