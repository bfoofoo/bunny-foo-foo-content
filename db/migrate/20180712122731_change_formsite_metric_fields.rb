class ChangeFormsiteMetricFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :formsites, :pixel_id, :string
    remove_column :formsites, :one_signal_id, :string
    add_column :formsites, :first_question_code_snippet, :text
    add_column :formsites, :head_code_snippet, :text
  end
end
