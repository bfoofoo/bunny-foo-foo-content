class ChangeLeadgenEntryDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :leadgen_rev_sites, :leadgen_entry, 'explore'
  end
end
