class ChangeQuestionFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :input_type
    remove_column :questions, :flow
  end
end
