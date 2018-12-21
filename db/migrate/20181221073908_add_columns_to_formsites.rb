class AddColumnsToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :size_slug, :string
    add_reference :formsites, :account
  end
end
