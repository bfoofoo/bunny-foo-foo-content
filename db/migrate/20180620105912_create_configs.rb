class CreateConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :configs do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.references :website, foreign_key: true

      t.timestamps
    end
  end
end
