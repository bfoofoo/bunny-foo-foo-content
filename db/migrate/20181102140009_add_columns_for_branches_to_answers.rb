class AddColumnsForBranchesToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :next_question_position, :integer
    add_column :answers, :last_question, :boolean, default: false
  end
end
