class RemoveFieldsFromAnswers < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :input_type, :string, default: "default"
    remove_column :answers, :flow, :string, default: "horizontal"
  end
end
