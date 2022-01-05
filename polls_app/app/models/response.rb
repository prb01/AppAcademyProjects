class AnswerChoice < ApplicationRecord
  validates :user_id, :question_id, :answer_choice_id, presence: true
  validates :user_id, uniqueness: { scope: [:question_id, :answer_choice_id] }

  belongs_to :question,
    class_name: :Question,
    foreign_key: :question_id,
    primary_key: :id

  belongs_to :answer_choice,
    class_name: :AnswerChoice,
    foreign_key: :answer_choice_id,
    primary_key: :id
  
  belongs_to :user,
    class_name: :User,
    foreign_key: :user_id,
    primary_key: :id
end