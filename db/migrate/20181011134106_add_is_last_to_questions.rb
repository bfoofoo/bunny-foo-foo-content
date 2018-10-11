class AddIsLastToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :is_last, :boolean, null: false, default: false
  end
end
