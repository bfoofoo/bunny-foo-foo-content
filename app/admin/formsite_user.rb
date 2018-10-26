ActiveAdmin.register FormsiteUser do
  menu false

  includes :formsite, :user, :exported_leads

  permit_params :affiliate, :job_key,  :s1, :s2, :s3, :s4, :s5, :ndm_token, :birthday, :phone, :zip, :ip

  filter :created_at
  filter :formsite
  filter :is_verified
  filter :is_useragent_valid
  filter :is_impressionwise_test_success
  filter :is_duplicate

  filter :created_at, :as => :date_range

  filter :affiliate
  filter :affiliate_blank,   :as => :boolean

  filter :job_key

  filter :s1
  filter :s1_blank,   :as => :boolean

  filter :s2
  filter :s2_blank,   :as => :boolean

  filter :s3
  filter :s3_blank,   :as => :boolean

  filter :s4
  filter :s4_blank,   :as => :boolean

  filter :s5
  filter :s5_blank,   :as => :boolean


  index do |fu|
    column :id
    column :created_at
    column :formsite
    column :user
    column :is_verified
    column :is_useragent_valid
    column :is_impressionwise_test_success
    column :is_duplicate
    column :is_email_duplicate
    column :affiliate
    column :job_key
    column :s1
    column :s2
    column :s3
    column :s4
    column :s5
    column :ip
    column :ndm_token
    column :birthday
    column :phone
    column :zip
    column "First name" do |formsite_user|
      span formsite_user&.user&.first_name
    end
    column "Last name" do |formsite_user|
      span formsite_user&.user&.last_name
    end
    User::ESP_LIST_TYPES.keys.each do |provider|
      column :"sent_to_#{provider}?" do |formsite_user|
        if formsite_user.send(:"local_sent_to_#{provider}?")
          span 'Yes', class: 'status_tag ok'
        elsif formsite_user.send(:"sent_to_#{provider}?")
          span 'Yes', class: 'status_tag errored'
        elsif formsite_user.user_id
          span 'No', class: 'status_tag no'
        end
      end
    end

    actions
  end

  csv do
    column :created_at

    column "formsite" do |formsite_user|
      formsite_user&.formsite&.name
    end

    column "user_id" do |formsite_user|
      formsite_user.user_id
    end
    column :is_verified
    column :is_useragent_valid
    column :is_impressionwise_test_success
    column :is_duplicate
    column :affiliate
    column :job_key
    column :s1
    column :s2
    column :s3
    column :s4
    column :s5
    column :ndm_token
    column :ip
    column "First name" do |formsite_user|
      formsite_user&.user&.first_name
    end

    column "Last name" do |formsite_user|
      formsite_user&.user&.last_name
    end

    column "Email" do |formsite_user|
      formsite_user&.user&.email
    end
  end
end
