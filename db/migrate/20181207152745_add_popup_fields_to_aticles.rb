class AddPopupFieldsToAticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :show_popup, :boolean, default: false
    add_column :articles, :popup_iframe_urls, :string, array: true, default: []
    add_column :articles, :popup_delay, :integer
  end
end
