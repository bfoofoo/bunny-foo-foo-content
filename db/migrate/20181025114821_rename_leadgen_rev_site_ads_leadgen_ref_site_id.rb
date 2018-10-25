class RenameLeadgenRevSiteAdsLeadgenRefSiteId < ActiveRecord::Migration[5.0]
  def change
    rename_column :leadgen_rev_site_ads, :leadgen_ref_site_id, :leadgen_rev_site_id
  end
end
