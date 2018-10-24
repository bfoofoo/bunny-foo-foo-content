class CreateLeadgenRevSiteUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :leadgen_rev_site_users do |t|
      t.references :leadgen_rev_site, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :is_verified
      t.boolean :is_useragent_valid
      t.boolean :is_impressionwise_test_success
      t.boolean :is_duplicate
      t.string :s4
      t.string :s5
      t.string :s1
      t.string :s2
      t.string :s3
      t.string :ndm_token
      t.string :affiliate
      t.datetime :birthday
      t.string :zip
      t.string :phone
      t.string :ip
      t.string :job_key
      t.datetime :deleted_at
      t.boolean :is_email_duplicate, default: false
      t.timestamps null: false
    end
  end
end
