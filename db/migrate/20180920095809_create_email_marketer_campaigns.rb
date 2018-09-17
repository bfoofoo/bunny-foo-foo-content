class CreateEmailMarketerCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :email_marketer_campaigns do |t|
      t.integer :campaign_id
      t.integer :list_ids, array: true, null: false, default: []
      t.string :subject
      t.string :origin
      t.string :source_url
      t.jsonb :stats, null: false, default: {}
      t.datetime :sent_at
    end
  end
end
