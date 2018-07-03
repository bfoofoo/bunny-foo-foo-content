class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :text
      t.references :question, foreign_key: true
      t.boolean :is_correct, :default => false

      t.timestamps
    end
  end
end
