class ApiUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :is_verified, :is_useragent_valid, :is_impressionwise_test_success, :is_duplicate, :website, :ip, :captured, :lead_id, :zip, :state, :phone1, :job
end
