class CreateFormsiteQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :formsite_questions do |t|
      t.integer :formsite_id
      t.integer :question_id

      t.timestamps
    end
  end
end
