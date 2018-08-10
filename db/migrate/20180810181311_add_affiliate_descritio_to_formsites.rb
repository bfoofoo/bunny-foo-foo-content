class AddAffiliateDescritioToFormsites < ActiveRecord::Migration[5.0]
  def change
    add_column :formsites, :affiliate_description, :string
  end
end
