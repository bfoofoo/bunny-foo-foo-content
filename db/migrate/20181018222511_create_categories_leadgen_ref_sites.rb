class CreateCategoriesLeadgenRefSites < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_leadgen_ref_sites do |t|
      t.references :leadgen_ref_site, foreign_key: true
      t.references :category, foreign_key: true
    end
  end
end
