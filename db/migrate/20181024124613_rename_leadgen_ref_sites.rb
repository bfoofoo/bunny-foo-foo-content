class RenameLeadgenRefSites < ActiveRecord::Migration[5.0]
  def change
    rename_table :leadgen_ref_sites, :leadgen_rev_sites
  end
end
