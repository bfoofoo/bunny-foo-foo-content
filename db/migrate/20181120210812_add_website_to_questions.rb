class AddWebsiteToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :website, foreign_key: true
  end
end
