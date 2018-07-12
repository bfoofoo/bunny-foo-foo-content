class AddFieldToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :innerHTML, :text
  end
end
