class AddFormBackgroundColorToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :form_background_color, :string
    add_column :leadgen_rev_sites, :form_text_color, :string
  end
end
