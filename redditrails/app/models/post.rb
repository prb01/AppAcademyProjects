class Post < ApplicationRecord
  validates :title, :author_id, presence: true
  validates :subs, presence: true

  belongs_to :author, class_name: 'User'
  has_many :post_subs, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :post_subs
end