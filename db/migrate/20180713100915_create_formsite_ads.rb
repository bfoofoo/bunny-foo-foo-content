class CreateFormsiteAds < ActiveRecord::Migration[5.0]
  def change
    create_table :formsite_ads do |t|
      t.references :formsite, foreign_key: true
      t.references :ad, foreign_key: true

      t.timestamps
    end
  end
end
