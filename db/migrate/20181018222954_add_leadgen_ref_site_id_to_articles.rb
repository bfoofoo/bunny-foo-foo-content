class AddLeadgenRefSiteIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :leadgen_ref_site_id, :integer
    add_index :articles, :leadgen_ref_site_id
  end
end
