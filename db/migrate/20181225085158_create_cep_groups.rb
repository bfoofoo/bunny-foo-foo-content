class CreateCepGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :cep_groups do |t|
      t.string :type
      t.string :name
      t.integer :group_id
      t.references :account, index: true, foreign_key: true

      t.timestamps
    end
  end
end
