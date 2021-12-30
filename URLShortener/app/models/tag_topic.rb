class TagTopic < ApplicationRecord
  validates :topic, presence: true, uniqueness: true

  has_many :taggings,
    class_name: 'Tagging',
    primary_key: :id,
    foreign_key: :tag_topic_id

  has_many :urls,
    through: :taggings,
    source: :url

  has_many :visits,
    through: :urls,
    source: :visits

  def popular_links
    self.visits.select(:url_id).group(:url_id).limit(5).count.to_a.map do |arr|
      [ShortenedUrl.find_by_id(arr[0]), arr[1]]
    end
  end
end