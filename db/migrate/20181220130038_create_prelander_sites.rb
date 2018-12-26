class CreatePrelanderSites < ActiveRecord::Migration[5.0]
  def change
    create_table :prelander_sites do |t|
      t.string   :name
      t.text     :description
      t.integer  :droplet_id
      t.integer  :droplet_ip
      t.integer  :zone_id
      t.string   :repo_url
      t.string   :favicon_image
      t.string   :logo_image
      t.string   :shortname
      t.string   :fraud_user_redirect_url
      t.string   :first_redirect_url
      t.string   :final_redirect_url
      t.string   :background
      t.text     :head_code_snippet
      t.string   :right_side_content
    
      t.timestamps
    end
  end
end
