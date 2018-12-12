class CreateMessageRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :message_recipients do |t|
      t.references :message_schedule, index: true, null: false, foreign_key: true
      t.string :email, null: false
      t.hstore :metadata
      t.datetime :sent_at
    end
  end
end
