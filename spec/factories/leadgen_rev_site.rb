FactoryBot.define do
  factory :leadgen_rev_site do
    sequence :name do |n|
      "leadgen_rev_site_name_#{n}"
    end
  end
end
