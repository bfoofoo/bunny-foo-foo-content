class ChangePrelenderInQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :for_prelender, :boolean, default: false
    add_column :questions, :for_prelander, :boolean, default: false
  end
end
