class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :artworks,
    class_name: 'Artwork',
    primary_key: :id,
    foreign_key: :artist_id

  has_many :viewers,
    -> { distinct },
    through: :artworks,
    source: :viewers
end