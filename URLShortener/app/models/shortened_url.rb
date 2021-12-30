require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  validate :no_spamming

  def no_spamming
    # cannot submit more than 5 URLs in a single minute
    if ShortenedUrl.last(5).first.created_at >= 1.minute.ago
      errors[:base] << 'Cannot submit more than 5 URLs within 1 minute'
    end
  end

  belongs_to :submitter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  has_many :visits,
    class_name: 'Visit',
    primary_key: :id,
    foreign_key: :url_id

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    class_name: 'Tagging',
    primary_key: :id,
    foreign_key: :url_id

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

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

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visits.select(:user_id).distinct.where("created_at >= ?", 10.minutes.ago).count
  end
end