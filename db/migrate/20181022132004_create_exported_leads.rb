class CreateExportedLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :exported_leads do |t|
      t.string   :list_type
      t.references :list, polymorphic: true
      t.references :linkable, polymorphic: true
      t.datetime :created_at
      t.references :esp_rule, index: true, foreign_key: true
      t.datetime :autoresponded_at
      t.string   :autoresponse_message_id
      t.datetime :clicked_at
      t.datetime :opened_at
      t.datetime :followed_up_at
    end
  end
end
