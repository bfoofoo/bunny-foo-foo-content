class CreateEmailMarketerMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :email_marketer_mappings do |t|
      t.references :source, polymorphic: true, index: { name: 'index_email_marketer_mappings_on_destination' }
      t.references :destination, polymorphic: true, index: { name: 'index_email_marketer_mappings_on_source'}
      t.date :start_date

      t.timestamps
    end
  end
end
