class CreateFormsites < ActiveRecord::Migration[5.0]
  def change
    create_table :formsites do |t|
      t.string :name
      t.text :description
      t.integer :droplet_id
      t.integer :droplet_ip
      t.integer :zone_id

      t.timestamps
    end
  end
end
