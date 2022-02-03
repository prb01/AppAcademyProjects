FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    author_id { 1 }
    commentable_type { "User" }
    commentable_id { 1 }
  end
end
