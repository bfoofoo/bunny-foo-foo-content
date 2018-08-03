class CreateApiClients < ActiveRecord::Migration[5.0]
  def change
    create_table :api_clients do |t|
      t.string :token
      t.string :name

      t.timestamps
    end
  end
end
