class ArtworkShare < ApplicationRecord
  validates :artwork_id, :viewer_id, presence: true
  validates :artwork_id, uniqueness: { scope: :viewer_id }

  belongs_to :viewer,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :viewer_id

  belongs_to :artwork,
    class_name: 'Artwork',
    primary_key: :id,
    foreign_key: :artwork_id

  has_one :artist,
    through: :artwork,
    source: :artist
end