FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    author_id { 1 }
    type { "user" }
    type_id { 1 }
  end
end
