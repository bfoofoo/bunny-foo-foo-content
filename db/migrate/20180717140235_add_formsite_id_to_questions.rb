class AddFormsiteIdToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :formsite, foreign_key: true
  end
end
