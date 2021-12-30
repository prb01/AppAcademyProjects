class Visit < ApplicationRecord
  validates :url_id, :user_id, presence: true

  belongs_to :url,
    class_name: 'ShortenedUrl',
    primary_key: :id,
    foreign_key: :url_id

  belongs_to :visitor,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id
  
  def self.record_visit!(user, shortened_url)
    Visit.create(url_id: shortened_url.id, user_id: user.id)
  end
end