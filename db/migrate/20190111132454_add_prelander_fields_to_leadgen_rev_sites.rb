class AddPrelanderFieldsToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    change_table :leadgen_rev_sites do |t|
      t.string :prelander_title
      t.string :prelander_main_text
      t.string :prelander_button_text
      t.string :prelander_image
    end
  end
end
