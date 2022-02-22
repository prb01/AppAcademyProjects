class PostSub < ApplicationRecord
  validates :post, :sub, presence: true
  validates :post_id, uniqueness: { scope: :sub_id }

  belongs_to :post
  belongs_to :sub
end