class Response < ApplicationRecord
  validates :user_id, :question_id, :answer_choice_id, presence: true
  validates :user_id, uniqueness: { scope: [:question_id, :answer_choice_id] }
  validate :not_duplicate_response
  validate :not_poll_author_response

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

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    sibling_responses.any? { |r| r.user_id == self.user_id }
  end

  def not_duplicate_response
    if respondent_already_answered?
      errors[:base] << 'User already responded to this question.'
    end
  end

  def is_author?
    self.question.poll.author_id == self.user_id
  end

  def not_poll_author_response
    if is_author?
      errors[:base] << 'Poll author cannot respond to question.'
    end
  end
end