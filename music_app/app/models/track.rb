class Track < ApplicationRecord
  validates :title, :ord, :album_id, presence: true

  belongs_to :album
  has_one :band,
    through: :album,
    source: :band
end