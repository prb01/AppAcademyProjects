class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :artworks,
    class_name: 'Artwork',
    primary_key: :id,
    foreign_key: :artist_id,
    dependent: :destroy

  has_many :artwork_shares,
    through: :artworks,
    source: :artwork_shares,
    dependent: :destroy

  has_many :shared_viewers,
    -> { distinct },
    through: :artworks,
    source: :shared_viewers
end