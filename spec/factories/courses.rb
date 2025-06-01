FactoryBot.define do
  factory :course do
    name { Faker::Company.name }
    heading { Faker::Company.catch_phrase }
    external_id { Faker::Number.number }
    is_published { Faker::Boolean.boolean }
  end
end
