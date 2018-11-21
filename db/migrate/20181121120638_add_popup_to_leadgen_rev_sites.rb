class AddPopupToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :show_popup, :boolean, default: false
    add_column :leadgen_rev_sites, :popup_iframe_urls, :string, array: true, default: []
    add_column :leadgen_rev_sites, :popup_delay, :integer
  end
end
