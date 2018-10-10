FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end

    first_name {"first_name"}
    last_name {"last_name"}
  end
end
