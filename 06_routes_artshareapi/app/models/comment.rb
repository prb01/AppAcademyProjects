class Comment < ApplicationRecord
  validates :body, :user_id, :artwork_id, presence: true

  belongs_to :artwork
  belongs_to :user
end