class RenameLeadgenRefSiteAds < ActiveRecord::Migration[5.0]
  def change
    rename_table :leadgen_ref_site_ads, :leadgen_rev_site_ads
  end
end
