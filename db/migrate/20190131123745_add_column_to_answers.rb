class AddColumnToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :add_params_from_question, :boolean, default: false
  end
end
