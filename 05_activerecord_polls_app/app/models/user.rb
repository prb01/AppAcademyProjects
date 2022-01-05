class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :polls,
    class_name: :Poll,
    foreign_key: :author_id,
    primary_key: :id
  
  has_many :responses,
    class_name: :Response,
    foreign_key: :user_id,
    primary_key: :id
  
  has_many :polls_responded,
    -> { distinct },
    through: :responses,
    source: :poll

  def completed_polls
    polls_with_qs_responses
      .having('COUNT(DISTINCT questions.id) = COALESCE(COUNT(DISTINCT responses.id),0)')
  end

  def uncompleted_polls
    polls_with_qs_responses
      .having('COUNT(DISTINCT questions.id) != COALESCE(COUNT(DISTINCT responses.id),0)')
      .having('COALESCE(COUNT(DISTINCT responses.id),0) > 0')
  end

  private
  def polls_with_qs_responses
    user_polls_ids = self.polls_responded.pluck(:id)

    Poll
      .joins(:questions)
      .left_joins(:responses)
      .where(id: user_polls_ids)
      .where(responses: { user_id: self.id })
      .group(:id)
  end
end