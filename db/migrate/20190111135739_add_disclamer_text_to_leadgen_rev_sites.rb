class AddDisclamerTextToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :disclaimer_text, :text
  end
end
