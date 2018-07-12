class CreateWebsiteAds < ActiveRecord::Migration[5.0]
  def change
    create_table :website_ads do |t|
      t.references :website, foreign_key: true
      t.references :ad, foreign_key: true

      t.timestamps
    end
  end
end
