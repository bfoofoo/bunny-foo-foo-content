class CreateArticlePopups < ActiveRecord::Migration[5.0]
  def change
    create_table :article_popups do |t|
      t.integer :article_id
      t.integer :leadgen_rev_site_id
      t.boolean :show_popup, default: false
      t.string :popup_iframe_urls, array: true, default: []
      t.integer :popup_delay

      t.timestamps
    end
    add_index :article_popups, :article_id
    add_index :article_popups, [:article_id, :leadgen_rev_site_id]
  end
end
