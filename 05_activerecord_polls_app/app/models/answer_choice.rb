class AnswerChoice < ApplicationRecord
  validates :answer_choice, :question_id, presence: true
  validates :answer_choice, uniqueness: { scope: :question_id }

  belongs_to :question,
    class_name: :Question,
    foreign_key: :question_id,
    primary_key: :id

  has_many :responses,
    class_name: :Response,
    primary_key: :id,
    foreign_key: :answer_choice_id,
    dependent: :destroy

  def self.no_responses
    AnswerChoice
      .left_joins(:responses)
      .where('responses.id IS NULL') 
    end
end