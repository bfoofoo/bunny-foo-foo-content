class CreateMessageTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :message_templates do |t|
      t.string :author
      t.string :subject
      t.text :body
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
