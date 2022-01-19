require 'action_view'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  COLORS = [
    "white",
    "black",
    "ginger",
    "grey",
    "cream",
    "brown",
    "cinnamon",
    "fawn",
    "mixed"
  ]

  validates :name, :sex, :birth_date, :color, presence: true
  validates :color, inclusion: { in: COLORS }
  validates :sex, inclusion: { in: %w(M F) }

  has_many :rental_requests,
    class_name: 'CatRentalRequest',
    primary_key: :id,
    foreign_key: :cat_id,
    dependent: :destroy


  def self.colors
    COLORS
  end

  def age
    time_ago_in_words(self.birth_date) 
  end
end