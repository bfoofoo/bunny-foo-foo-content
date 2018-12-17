class CreatePixelCodeSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :pixel_code_snippets do |t|
      t.string :leadgen_entry
      t.integer :leadgen_rev_site_id
      t.string :first_question_code_snippet

      t.timestamps
    end
  end
end
