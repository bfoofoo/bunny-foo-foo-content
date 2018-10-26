class RenameCategoriesLeadgenRevSitesLeadgenRefSiteId < ActiveRecord::Migration[5.0]
  def change
    rename_column :categories_leadgen_rev_sites, :leadgen_ref_site_id, :leadgen_rev_site_id
  end
end
