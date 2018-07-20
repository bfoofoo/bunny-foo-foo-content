ActiveAdmin.register FormsiteUser do
  index do |poll|
    column :created_at
    column :formsite
    column :user
    column :is_verified
    column :is_useragent_valid
    column :is_impressionwise_test_success
    column :is_duplicate
  end

end
