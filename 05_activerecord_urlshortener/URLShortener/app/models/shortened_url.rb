require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  validate :no_spamming
  validate :nonpremium_max

  def no_spamming
    # cannot submit more than 5 URLs in a single minute
    record = self.submitter.submitted_urls.last(5)

    if record.count == 5 && record.first.created_at >= 1.minute.ago
      errors[:base] << 'Cannot submit more than 5 URLs within 1 minute'
    end
  end

  def nonpremium_max
    # cannot submit more than 5 urls if not premium user
    num_submitted = self.submitter.submitted_urls.count
    prem_status = self.submitter.premium
    
    unless prem_status || num_submitted <= 5
      errors[:base] << 'No pay, no play (max 5 submissions)'
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
    shortened_url = ShortenedUrl.new(long_url: long_url, 
      short_url: ShortenedUrl.random_code,
      user_id: user.id)
    shortened_url.save!
    shortened_url
  end

  def self.prune(n)
    prune_urls = ShortenedUrl.joins(:submitter).left_joins(:visits).where("users.premium = false").group(:id).having("MAX(visits.created_at) <= ? OR MAX(visits.created_at) IS NULL", n.minutes.ago)
    prune_urls.each do |url| 
      url.visits.destroy_all
      url.taggings.destroy_all
    end
    prune_urls.destroy_all
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