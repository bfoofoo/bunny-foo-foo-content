FactoryBot.define do
  factory :formsite do
    sequence :name do |n|
      "formsite_name_#{n}"
    end
  end
end
