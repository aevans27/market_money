FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    contact_name { Faker::Lorem.paragraph }
    contact_phone { Faker::Lorem.paragraph }
    credit_accepted { Faker::Boolean.boolean }
  end
end