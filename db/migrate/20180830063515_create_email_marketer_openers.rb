class CreateEmailMarketerOpeners < ActiveRecord::Migration[5.0]
  def change
    create_table :email_marketer_openers do |t|
      t.references :source_list, polymorphic: true, index: { name: 'index_email_marketer_openers_on_source' }
      t.string :affiliate
      t.string :email

      t.timestamps null: false
    end
  end
end
