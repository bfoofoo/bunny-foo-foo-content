class CreateLeadgenRefSites < ActiveRecord::Migration[5.0]
  def change
    create_table :leadgen_ref_sites do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :droplet_id
      t.string :droplet_ip
      t.string :zone_id
      t.string :repo_url
      t.string :favicon_image
      t.string :logo_image
      t.string :shortname
      t.string :text_file
      t.datetime :deleted_at
      t.string :ad_client
      t.string :ad_sidebar_id
      t.string :ad_top_id
      t.string :ad_middle_id
      t.string :ad_bottom_id
      t.string :first_redirect_url
      t.string :final_redirect_url
      t.boolean :is_thankyou
      t.string :background
      t.text :left_side_content
      t.text :first_question_code_snippet
      t.text :head_code_snippet
      t.boolean :is_checkboxes
      t.string :right_side_content
      t.string :s1_description
      t.string :s2_description
      t.string :s3_description
      t.string :s4_description
      t.string :s5_description
      t.string :form_box_title_text
      t.string :affiliate_description
      t.boolean :is_phone_number

      t.timestamps
    end
    add_index :leadgen_ref_sites, :deleted_at
  end
end
