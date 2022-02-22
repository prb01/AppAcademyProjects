class Comment < ApplicationRecord
  validates :content, :post_id, :author_id, presence: true

  belongs_to :post
  belongs_to :author, class_name: 'User'
  belongs_to :parent, class_name: 'Comment', primary_key: :id, foreign_key: :parent_comment_id, optional: true

  
end