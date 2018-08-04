ActiveAdmin.register ApiUser do
  permit_params :email, :first_name, :last_name, :is_verified, :is_useragent_valid, :is_impressionwise_test_success, :is_duplicate, :s1, :s2, :s3, :s4, :s5, :website, :api_client_id

  scope :all, :default => true
  scope :verified do
    ApiUser.where("is_verified = ?", true)
  end
  scope :is_useragent_valid do
    ApiUser.where("is_useragent_valid = ?", true)
  end
  scope :is_impressionwise_test_success do
    ApiUser.where("is_impressionwise_test_success = ?", true)
  end
  scope :is_duplicate do
    ApiUser.where("is_duplicate = ?", true)
  end
end
