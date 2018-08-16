class CreateFormsiteAweberLists < ActiveRecord::Migration[5.0]
  def change
    create_table :formsite_aweber_lists do |t|
      t.integer :aweber_list_id
      t.integer :formsite_id

      t.timestamps
    end
  end
end
