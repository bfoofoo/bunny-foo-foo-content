class AddPrelanderFinalRedirectUrlToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :prelander_final_redirect_url, :string
  end
end
