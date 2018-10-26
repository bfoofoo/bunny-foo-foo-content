class AddDomainsToEmailMarketerMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :email_marketer_mappings, :domain, :string
  end
end
