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

  def age
    time_ago_in_words(self.birth_date) 
  end
end