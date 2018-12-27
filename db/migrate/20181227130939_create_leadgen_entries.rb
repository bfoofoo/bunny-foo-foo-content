class CreateLeadgenEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :leadgen_entries do |t|
      t.string :entry, null: false
      t.references :leadgen_rev_site, index: true, foreign_key: true
      t.string :background
      t.string :background_color
      t.integer :background_opacity
      t.text :left_side_content
      t.text :right_side_content
      t.string :form_box_title_text
      t.datetime :deleted_at
    end
  end
end
