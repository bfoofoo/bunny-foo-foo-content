class RenameArticlesLeadgenRefSiteId < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles, :leadgen_ref_site_id, :leadgen_rev_site_id
  end
end
