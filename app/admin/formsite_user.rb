ActiveAdmin.register FormsiteUser do
  
  filter :created_at
  filter :formsite
  filter :user
  filter :is_verified
  filter :is_useragent_valid
  filter :is_impressionwise_test_success
  filter :is_duplicate

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
    column :created_at
    column :formsite
    column :user
    column :is_verified
    column :is_useragent_valid
    column :is_impressionwise_test_success
    column :is_duplicate
    column :s1
    column :s2
    column :s3
    column :s4
    column :s5
    column "First name" do |user|
      span user.user.first_name
    end
    column "Last name" do |user|
      span user.user.last_name
    end
  end

  csv do
    column :created_at
    column :formsite
    column :user
    column :is_verified
    column :is_useragent_valid
    column :is_impressionwise_test_success
    column :is_duplicate
    column :s1
    column :s2
    column :s3
    column :s4
    column :s5
    column :ndm_token
    column "First name" do |user|
      user.user.first_name
    end
    column "Last name" do |user|
      user.user.last_name
    end
  end
end