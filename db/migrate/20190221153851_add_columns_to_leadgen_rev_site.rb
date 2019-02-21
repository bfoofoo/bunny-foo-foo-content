class AddColumnsToLeadgenRevSite < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :index_page_title, :text
    add_column :leadgen_rev_sites, :index_page_subtitle, :text
    add_column :leadgen_rev_sites, :index_page_description, :text
  end
end
