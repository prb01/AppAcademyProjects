require 'faker'

User.destroy_all
Goal.destroy_all
Comment.destroy_all

ApplicationRecord.connection.reset_pk_sequence!('users')
ApplicationRecord.connection.reset_pk_sequence!('goals')
ApplicationRecord.connection.reset_pk_sequence!('comments')

puts "create users"
u1 = User.create(email: Faker::Internet.email, password: 'password')
u2 = User.create(email: Faker::Internet.email, password: 'password')
u3 = User.create(email: Faker::Internet.email, password: 'password')
u4 = User.create(email: Faker::Internet.email, password: 'password')

puts "create goals"
g1 = Goal.create(user_id: u1.id, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))
g2 = Goal.create(user_id: u1.id, completed: true, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))
g3 = Goal.create(user_id: u1.id, private: true, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))
g4 = Goal.create(user_id: u1.id, private: true, completed: true, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))

g5 = Goal.create(user_id: u2.id, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))
g6 = Goal.create(user_id: u2.id, completed: true, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))
g7 = Goal.create(user_id: u2.id, private: true, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))
g8 = Goal.create(user_id: u2.id, private: true, completed: true, title: Faker::Lorem.sentence, details: Faker::Lorem.sentences.join(" "))

puts "create comments for users"
Comment.create(author_id: u1.id, commentable_id: u2.id, commentable_type: "User", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u1.id, commentable_id: u3.id, commentable_type: "User", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u1.id, commentable_id: u4.id, commentable_type: "User", body: Faker::Lorem.sentences.join(" "))

Comment.create(author_id: u2.id, commentable_id: u1.id, commentable_type: "User", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u3.id, commentable_id: u1.id, commentable_type: "User", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u4.id, commentable_id: u1.id, commentable_type: "User", body: Faker::Lorem.sentences.join(" "))

puts "create comments for goals"
Comment.create(author_id: u2.id, commentable_id: g1.id, commentable_type: "Goal", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u2.id, commentable_id: g2.id, commentable_type: "Goal", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u3.id, commentable_id: g1.id, commentable_type: "Goal", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u3.id, commentable_id: g2.id, commentable_type: "Goal", body: Faker::Lorem.sentences.join(" "))

Comment.create(author_id: u1.id, commentable_id: g5.id, commentable_type: "Goal", body: Faker::Lorem.sentences.join(" "))
Comment.create(author_id: u1.id, commentable_id: g6.id, commentable_type: "Goal", body: Faker::Lorem.sentences.join(" "))