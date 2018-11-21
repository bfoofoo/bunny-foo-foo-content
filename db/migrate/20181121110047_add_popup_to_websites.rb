class AddPopupToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :show_popup, :boolean, default: false
    add_column :websites, :popup_iframe_urls, :string, array: true, default: []
    add_column :websites, :popup_delay, :integer
  end
end
