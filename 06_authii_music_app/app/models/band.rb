class Band < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :albums,
    foreign_key: :artist_id,
    dependent: :destroy
  
  has_many :tracks,
    through: :albums,
    source: :tracks
end