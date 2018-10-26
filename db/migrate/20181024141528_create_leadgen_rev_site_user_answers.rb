class CreateLeadgenRevSiteUserAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :leadgen_rev_site_user_answers do |t|
      t.references :user, foreign_key: true
      t.references :leadgen_rev_site, foreign_key: true
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true
      t.references :leadgen_rev_site_user, foreign_key: true
      t.timestamps null: false
    end
  end
end
