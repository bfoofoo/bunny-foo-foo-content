class CreateSuppresionLists < ActiveRecord::Migration[5.0]
  def change
    create_table :suppresion_lists do |t|
      t.string :file

      t.timestamps
    end
  end
end
