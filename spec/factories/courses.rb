FactoryBot.define do
  factory :course do
    name { Faker::Business.name }
    heading { Faker::Business.name }
    external_id { Faker::Number.number }
    is_published { Faker::Boolean.boolean }
  end
end
