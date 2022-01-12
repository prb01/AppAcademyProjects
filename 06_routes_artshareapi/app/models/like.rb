class Like < ApplicationRecord
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:comment_id, :artwork_id] }
  validate :only_like_one_of_artwork_or_comment

  belongs_to :user
  belongs_to :comment, optional: true
  belongs_to :artwork, optional: true

  private

  def only_like_one_of_artwork_or_comment
    if (!artwork_id && comment_id) || (artwork_id && !comment_id)
      return true
    else
      errors[:base] << "One of artwork_id or comment_id must NOT be NULL"
    end
  end
end