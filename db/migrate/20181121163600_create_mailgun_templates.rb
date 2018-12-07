class CreateMailgunTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :mailgun_templates do |t|
      t.references :mailgun_list, index: true, foreign_key: true
      t.string :author
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
