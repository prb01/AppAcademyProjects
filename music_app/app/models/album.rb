class Album < ApplicationRecord
  validates :title, :year, :artist_id, presence: true
  validate :year_not_more_than_current_year

  belongs_to :band,
    foreign_key: :artist_id

  has_many :tracks,
    dependent: :destroy

  private

  def year_not_more_than_current_year
    if self.year > Date.today.year
      errors[:year] << "cannot be in the future."
    else
      return true
    end
  end
end