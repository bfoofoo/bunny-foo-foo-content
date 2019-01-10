class AddCustomFieldIdToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :custom_field, foreign_key: true
  end
end
