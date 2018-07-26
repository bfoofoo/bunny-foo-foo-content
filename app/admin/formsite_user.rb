ActiveAdmin.register FormsiteUser do
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
    column "First name" do |user|
      user.user.first_name
    end
    column "Last name" do |user|
      user.user.last_name
    end
  end

end
