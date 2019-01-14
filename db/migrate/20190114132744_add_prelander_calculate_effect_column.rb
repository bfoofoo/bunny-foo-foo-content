class AddPrelanderCalculateEffectColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :prelander_calculate_effect, :string
  end
end
