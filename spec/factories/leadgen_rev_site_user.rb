FactoryBot.define do
  factory :leadgen_rev_site_user do
    leadgen_rev_site
    user
    ip {"192.168.0.101"}
  end
end
