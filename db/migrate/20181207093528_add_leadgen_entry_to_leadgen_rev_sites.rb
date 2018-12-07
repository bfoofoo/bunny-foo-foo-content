class AddLeadgenEntryToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :leadgen_entry, :string
  end
end
