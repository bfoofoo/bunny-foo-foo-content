class CreateLeadgenRevSitePopups < ActiveRecord::Migration[5.0]
  def change
    create_table :leadgen_rev_site_popups do |t|
      t.string :page_name
      t.integer :popup_delay
      t.string :popup_url
      t.references :leadgen_rev_site
      t.timestamps
    end
  end
end

