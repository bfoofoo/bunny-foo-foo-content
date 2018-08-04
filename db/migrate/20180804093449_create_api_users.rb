class CreateApiUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :api_users do |t|
      t.references :api_client, foreign_key: true
      t.string :email
      t.string :first_name
      t.string :last_name
      t.boolean :is_verified
      t.boolean :is_useragent_valid
      t.boolean :is_impressionwise_test_success
      t.boolean :is_duplicate
      t.string :s1
      t.string :s2
      t.string :s3
      t.string :s4
      t.string :s5
      t.string :website

      t.timestamps
    end
  end
end
