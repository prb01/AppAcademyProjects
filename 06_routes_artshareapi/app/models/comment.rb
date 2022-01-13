class Comment < ApplicationRecord
  validates :body, :user_id, :artwork_id, presence: true

  belongs_to :artwork
  belongs_to :user

  has_many :likes,
    class_name: 'Like',
    primary_key: :id,
    foreign_key: :comment_id,
    dependent: :destroy
  
  has_many :user_likes,
    through: :likes,
    source: :user
end