class RenameCategoriesLeadgenRefSites < ActiveRecord::Migration[5.0]
  def change
    rename_table :categories_leadgen_ref_sites, :categories_leadgen_rev_sites
  end
end
