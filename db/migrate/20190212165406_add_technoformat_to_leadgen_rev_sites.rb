class AddTechnoformatToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :technoformat, :boolean, default: false
  end
end
