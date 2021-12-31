class Tagging < ApplicationRecord
  validates :tag_topic_id, :url_id, presence: true

  belongs_to :url,
    class_name: 'ShortenedUrl',
    primary_key: :id,
    foreign_key: :url_id
  
  belongs_to :tag_topic,
    class_name: 'TagTopic',
    primary_key: :id,
    foreign_key: :tag_topic_id
end