class AddFormsiteUserIdToAnswers < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :user_id, :integer
    add_column :answers, :formsite_user_id, :integer
  end
end
