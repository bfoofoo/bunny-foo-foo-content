class CreatePrelanderSiteUserAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :prelander_site_user_answers do |t|
      t.integer  :user_id
      t.integer  :prelander_site_id
      t.integer  :question_id
      t.integer  :answer_id
      t.integer  :prelander_site_user_id
      t.string   :url

      t.timestamps
    end
  end
end
