class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :artworks,
    class_name: 'Artwork',
    primary_key: :id,
    foreign_key: :artist_id,
    dependent: :destroy

  has_many :artwork_shares,
    class_name: 'ArtworkShare',
    primary_key: :id,
    foreign_key: :viewer_id

  has_many :shared_viewers,
    -> { distinct },
    through: :artworks,
    source: :shared_viewers

  has_many :viewed_artworks,
    through: :artwork_shares,
    source: :artwork

end