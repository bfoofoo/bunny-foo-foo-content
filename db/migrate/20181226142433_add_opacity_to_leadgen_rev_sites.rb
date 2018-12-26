class AddOpacityToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :background_opacity, :integer
    add_column :leadgen_rev_sites, :background_color, :string
  end
end
