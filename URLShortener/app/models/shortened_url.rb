require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  def self.random_code
    url = nil
    while !url || ShortenedUrl.exists?(short_url: url)
      url = "https://www.prb01.com/#{SecureRandom.urlsafe_base64}"
    end
    url
  end

  def self.create!(user, long_url)
    ShortenedUrl.create(long_url: long_url, 
      short_url: ShortenedUrl.random_code,
      user_id: user.id)
  end
end