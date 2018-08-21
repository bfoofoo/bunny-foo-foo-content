class CreateFormsiteMaropostLists < ActiveRecord::Migration[5.0]
  def change
    create_table :formsite_maropost_lists do |t|
      t.references :maropost_list, null: false, foreign_key: true
      t.references :formsite, null: false, foreign_key: true
    end
  end
end
