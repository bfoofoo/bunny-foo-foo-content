class CreateSmsSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :sms_subscribers do |t|
      t.string :provider
      t.references :linkable, polymorphic: true
      t.references :source, polymorphic: true

      t.timestamps
    end
  end
end
