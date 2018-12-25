class CreateCepRules < ActiveRecord::Migration[5.0]
  def change
    create_table :cep_rules do |t|
      t.references :cep_group
      t.references :leadgen_rev_site, index: true, foreign_key: true

      t.timestamps
    end
  end
end
