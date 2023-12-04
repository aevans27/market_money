FactoryBot.define do
  factory :market do
    name { Faker::Company.name }
    street { Faker::Lorem.paragraph }
    city { Faker::Lorem.paragraph }
    county { Faker::Lorem.paragraph }
    state { Faker::Lorem.paragraph }
    zip { Faker::Number.number }
    lat { Faker::Number.decimal }
    lon { Faker::Number.decimal }
  end
end