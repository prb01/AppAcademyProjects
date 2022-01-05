# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Poll.destroy_all
Question.destroy_all
AnswerChoice.destroy_all
Response.destroy_all

ApplicationRecord.connection.reset_pk_sequence!('users')
ApplicationRecord.connection.reset_pk_sequence!('polls')
ApplicationRecord.connection.reset_pk_sequence!('questions')
ApplicationRecord.connection.reset_pk_sequence!('answer_choices')
ApplicationRecord.connection.reset_pk_sequence!('responses')

ApplicationRecord.transaction do
	puts 'Loading users...'
	require_relative 'data/users_import.rb'

	puts 'Loading polls...'
	require_relative 'data/polls_import.rb'

	puts 'Loading questions...'
	require_relative 'data/questions_import.rb'

  puts 'Loading questions...'
	require_relative 'data/answer_choices_import.rb'

  puts 'Loading questions...'
	require_relative 'data/responses_import.rb'

	puts 'Done!'
end