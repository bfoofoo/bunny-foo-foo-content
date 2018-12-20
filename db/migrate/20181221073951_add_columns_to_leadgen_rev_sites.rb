class AddColumnsToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :size_slug, :string
    add_reference :leadgen_rev_sites, :account
  end
end
