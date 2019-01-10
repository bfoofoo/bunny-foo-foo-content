class AddForPrelenderToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :for_prelender, :boolean, default: false
  end
end
