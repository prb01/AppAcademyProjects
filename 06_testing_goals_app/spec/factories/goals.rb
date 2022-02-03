FactoryBot.define do
  factory :goal do
    title { Faker::Lorem.sentence }
    details { Faker::Lorem.sentences.join(" ") }
    private { false }
    completed { false }
    user_id { 1 }
  end
end
