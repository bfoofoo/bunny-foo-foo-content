class CreateAds < ActiveRecord::Migration[5.0]
  def change
    create_table :ads do |t|
      t.string :type
      t.text :widget
      t.string :google_id
      t.string :position

      t.timestamps
    end
  end
end
