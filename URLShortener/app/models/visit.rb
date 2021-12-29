class Visit < ApplicationRecord
  validates :url_id, :user_id, presence: true

  has_many :url,
    class_name: 'ShortenedUrl',
    primary_key: :url_id,
    foreign_key: :id

  has_many :visitor,
    class_name: 'User',
    primary_key: :user_id,
    foreign_key: :id
  
  def self.record_visit!(user, shortened_url)
    Visit.create(url_id: shortened_url.id, user_id: user.id)
  end
end