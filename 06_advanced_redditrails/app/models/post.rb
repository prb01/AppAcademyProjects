class Post < ApplicationRecord
  validates :title, :author_id, presence: true
  validates :subs, presence: true

  belongs_to :author, class_name: 'User'
  has_many :post_subs, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :post_subs
  has_many :comments

  def parent_comments
    self.comments
      .where(parent_comment_id: [nil, ""])
  end

  def comments_by_parent_id
    comments_hash = Hash.new { |h,k| h[k] = [] }
    self.comments.includes(:author).each do |comment|
      comments_hash[comment.parent_comment_id] << comment
    end
    comments_hash
  end
end