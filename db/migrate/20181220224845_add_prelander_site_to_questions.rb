class AddPrelanderSiteToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :prelander_site, foreign_key: true
  end
end
