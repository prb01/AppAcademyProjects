class Poll < ApplicationRecord
  validates :title, :author_id, presence: true
  validates :title, uniqueness: { scope: :author_id }

  belongs_to :author,
    class_name: :User,
    foreign_key: :author_id,
    primary_key: :id

  has_many :questions,
    class_name: :Question,
    primary_key: :id,
    foreign_key: :poll_id

  has_many :answer_choices,
    through: :questions,
    source: :answer_choices
  
  has_many :responses,
    through: :questions,
    source: :responses 
end