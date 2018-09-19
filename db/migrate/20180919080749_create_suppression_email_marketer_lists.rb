class CreateSuppressionEmailMarketerLists < ActiveRecord::Migration[5.0]
  def change
    create_table :suppression_email_marketer_lists do |t|
      t.references :suppression_list, null: false, foreign_key: true, index: { name: 'index_suppression_lists_on_esp_lists_suppression_list_id' }
      t.references :removable, null: false, polymorphic: true, index: { name: 'index_suppression_lists_on_removable'}
    end
  end
end
