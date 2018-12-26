class AddColumnToPrelanderSite < ActiveRecord::Migration[5.0]
  def change
    add_column :prelander_sites, :size_slug, :string
    add_reference :prelander_sites, :account
  end
end
