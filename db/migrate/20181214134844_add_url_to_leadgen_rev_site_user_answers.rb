class AddUrlToLeadgenRevSiteUserAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_site_user_answers, :url, :string
  end
end
