class Artwork < ApplicationRecord
  validates :title, :image_url, :artist_id, presence: true
  validates :title, uniqueness: { scope: :artist_id }

  belongs_to :artist,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :artist_id

  has_many :artwork_shares,
    class_name: 'ArtworkShare',
    primary_key: :id,
    foreign_key: :artwork_id

  has_many :shared_viewers,
    through: :artwork_shares,
    source: :viewer

  has_many :comments,
    class_name: 'Comment',
    primary_key: :id,
    foreign_key: :artwork_id,
    dependent: :destroy

  has_many :likes,
    class_name: 'Like',
    primary_key: :id,
    foreign_key: :artwork_id,
    dependent: :destroy

  has_many :user_likes,
    through: :likes,
    source: :user
end