class AddPositionToFormsiteQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :formsite_questions, :position, :integer
  end
end
