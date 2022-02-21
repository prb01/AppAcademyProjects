class Sub < ApplicationRecord
  validates :title, :description, :moderator_id, presence: true
  validates :title, uniqueness: true

  belongs_to :mod,
    class: 'User',
    primary_key: :id,
    foreign_key: :moderator_id
end