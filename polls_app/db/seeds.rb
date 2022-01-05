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
	users_import

	puts 'Loading polls...'
	polls_import

	puts 'Loading questions...'
	questions_import

  puts 'Loading questions...'
	answer_choices_import

  puts 'Loading questions...'
	responses_import

	puts 'Done!'
end

def users_import
  User.import(
    [:username],
    [['Patrick'],
    ['Boris'],
    ['Caro'],
    ['Denny'],
    ['Jonny'],
    ['caro_clone_1'],
    ['caro_clone_2'],
    ['denny_clone_1'],
    ['jonny_clone_1']]
  )
end

def polls_import
  Poll.import(
    [:title, :author_id],
    [['Crypto', 1],
    ['Covid-19 measures', 1],
    ['Foreign policy', 2]]
  )
end

def questions_import
  Question.import(
    [:question, :poll_id],
    [['Should stablecoins be allowed?', 1],
    ['Is lawsuit against XRP warranted?', 1],
    ['Should SEC regulate ALL crypto market?', 1],
    ['Do you think US is falling behind in crypto regulation?', 1],
    ['Where should masks be worn?', 2],
    ['Should vaccinations be mandated?', 2],
    ['Do you believe in COVID conspiracies?', 2],
    ['Should Russia be warned?', 3],
    ['Should Iran be allowed to do nuclear stuff?', 3],
    ['Should North Korea be taken seriously?', 3]]
  )
end



def answer_choices_import
  AnswerChoice.import(
    [:answer_choice, :question_id],
    [['yes', 1],
    ['no', 1],
    ['don\'t know', 1],
    ['yes', 2],
    ['no', 2],
    ['don\'t know', 2],
    ['yes', 3],
    ['no', 3],
    ['don\'t know', 3],
    ['yes', 4],
    ['no', 4],
    ['don\'t know', 4],
    ['inside only', 5],
    ['inside & outside', 5],
    ['nowhere', 5],
    ['yes', 6],
    ['no', 6],
    ['don\'t know', 6],
    ['yes', 7],
    ['no', 7],
    ['don\'t know', 7],
    ['yes', 8],
    ['no', 8],
    ['don\'t know', 8],
    ['yes', 9],
    ['no', 9],
    ['don\'t know', 9],
    ['yes', 10],
    ['no', 10],
    ['don\'t know', 10]]
  )
end

def responses_import
  AnswerChoice.import(
    [:user_id, :question_id, :answer_choice_id],
    [[3, 1, 1],
    [3, 2, 5],
    [3, 3, 8],
    [3, 4, 10],
    [3, 5, 13],
    [3, 6, 16],
    [3, 7, 20],
    [3, 8, 22],
    [3, 9, 25],
    [3, 10, 29],

    [4, 1, 3],
    [4, 2, 4],
    [4, 3, 7],
    [4, 4, 12],
    [4, 5, 14],
    [4, 6, 17],
    [4, 7, 19],
    [4, 8, 24],
    [4, 9, 27],
    [4, 10, 30],

    [5, 1, 2],
    [5, 2, 6],
    [5, 3, 9],
    [5, 4, 11],
    [5, 5, 15],
    [5, 6, 18],
    [5, 7, 21],
    [5, 8, 24],
    [5, 9, 25],
    [5, 10, 29],

    [6, 1, 1],
    [6, 2, 5],
    [6, 3, 8],
    [6, 4, 10],
    [6, 5, 13],
    [6, 6, 16],
    [6, 7, 20],
    [6, 8, 22],
    [6, 9, 25],
    [6, 10, 29],

    [7, 1, 1],
    [7, 2, 5],
    [7, 3, 8],
    [7, 4, 10],
    [7, 5, 13],
    [7, 6, 16],
    [7, 7, 20],
    [7, 8, 22],
    [7, 9, 25],
    [7, 10, 29],

    [8, 1, 3],
    [8, 2, 4],
    [8, 3, 7],
    [8, 4, 12],
    [8, 5, 14],
    [8, 6, 17],
    [8, 7, 19],
    [8, 8, 24],
    [8, 9, 27],
    [8, 10, 30],

    [9, 1, 2],
    [9, 2, 6],
    [9, 3, 9],
    [9, 4, 11],
    [9, 5, 15],
    [9, 6, 18],
    [9, 7, 21],
    [9, 8, 24],
    [9, 9, 25],
    [9, 10, 29],
    ]
  )
end