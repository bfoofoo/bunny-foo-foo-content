class CreateArticlesLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    create_table :articles_leadgen_rev_sites do |t|
      t.belongs_to :article
      t.belongs_to :leadgen_rev_site
      t.timestamps
    end
  end
end
