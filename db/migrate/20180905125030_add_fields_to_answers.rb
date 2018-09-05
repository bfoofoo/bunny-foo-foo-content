class AddFieldsToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :input_type, :string, default: "default"
    add_column :answers, :flow, :string, default: "horizontal"
  end
end