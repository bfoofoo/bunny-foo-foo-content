class CreateFormsiteUserAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :formsite_user_answers do |t|
      t.integer :user_id
      t.integer :formsite_id
      t.integer :question_id
      t.integer :answer_id
      t.integer :formsite_user_id

      t.timestamps
    end
  end
end
