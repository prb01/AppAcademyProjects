class Comment < ApplicationRecord
  validates :body, :author_id, :commentable_type, :commentable_id, presence: true

  belongs_to :author, class_name: 'User', primary_key: :id, foreign_key: :author_id
  belongs_to :commentable, polymorphic: true
end