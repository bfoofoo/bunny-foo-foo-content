class AddLeadgenRevSiteToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :leadgen_rev_site, foreign_key: true
  end
end
