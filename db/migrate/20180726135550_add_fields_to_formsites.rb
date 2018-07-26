class AddFieldsToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :s1_description, :string
    add_column :formsites, :s2_description, :string
    add_column :formsites, :s3_description, :string
    add_column :formsites, :s4_description, :string
    add_column :formsites, :s5_description, :string
  end
end
