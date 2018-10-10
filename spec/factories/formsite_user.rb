FactoryBot.define do
  factory :formsite_user do
    formsite
    user
    ip {"192.168.0.100"}
  end
end
