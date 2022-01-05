class Question < ApplicationRecord
  validates :question, :poll_id, presence: true
  validates :question, uniqueness: { scope: :poll_id }

  belongs_to :poll,
    class_name: :Poll,
    foreign_key: :poll_id,
    primary_key: :id

  has_many :answer_choices,
    class_name: :AnswerChoice,
    primary_key: :id,
    foreign_key: :question_id
  
  has_many :responses,
    class_name: :Response,
    primary_key: :id,
    foreign_key: :question_id
end