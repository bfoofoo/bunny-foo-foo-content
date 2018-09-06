class AddFieldsToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :input_type, :string, default: "default"
    add_column :questions, :flow, :string, default: "horizontal"
  end
end
