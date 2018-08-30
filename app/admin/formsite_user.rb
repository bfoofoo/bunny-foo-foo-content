ActiveAdmin.register FormsiteUser do
  permit_params :affiliate, :s1, :s2, :s3, :s4, :s5, :ndm_token, :birthday, :phone, :zip
  
  

  filter :created_at
  filter :formsite
  filter :user
  filter :is_verified
  filter :is_useragent_valid
  filter :is_impressionwise_test_success
  filter :is_duplicate

  filter :affiliate
  filter :affiliate_blank,   :as => :boolean

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

  
  index do |poll|
    column :id
    column :created_at
    column :formsite
    column :user
    column :is_verified
    column :is_useragent_valid
    column :is_impressionwise_test_success
    column :is_duplicate
    column :affiliate
    column :s1
    column :s2
    column :s3
    column :s4
    column :s5
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
    column :s1
    column :s2
    column :s3
    column :s4
    column :s5
    column :ndm_token
    column "First name" do |formsite_user|
      formsite_user&.user&.first_name
    end

    column "First name" do |formsite_user|
      formsite_user&.user&.first_name
    end

    column "Email" do |formsite_user|
      formsite_user&.user&.email
    end
  end
end
