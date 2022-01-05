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

  def results
    responses = self.answer_choices
      .select('answer_choices.*, COALESCE(COUNT(responses.id), 0) AS count_responses')
      .left_joins(:responses)
      .where(question_id: self.id)
      .group('answer_choices.id')
      .order('count_responses DESC')

    results = {}
    responses.each do |r|
      results[r.answer_choice] = r.count_responses
    end
    results
  end
end