class CreateLeadgenRefSiteAds < ActiveRecord::Migration[5.0]
  def change
    create_table :leadgen_ref_site_ads do |t|
      t.references :leadgen_ref_site, foreign_key: true
      t.references :ad, foreign_key: true

      t.timestamps
    end
  end
end
