class CreatePrelanderSiteUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :prelander_site_users do |t|
      t.boolean  :is_verified
      t.boolean  :is_useragent_valid
      t.boolean  :is_impressionwise_test_success
      t.boolean  :is_duplicate
      t.string   :s4
      t.string   :s5
      t.string   :s1
      t.string   :s2
      t.string   :s3
      t.string   :ndm_token
      t.string   :affiliate
      t.datetime :birthday
      t.string   :zip
      t.string   :phone
      t.string   :ip
      t.string   :job_key
      t.boolean  :is_email_duplicate,             default: false
      t.string   :url
      t.string   :state
      t.boolean  :sms_compliant,                  default: false
      
      t.timestamps
    end
  end
end
