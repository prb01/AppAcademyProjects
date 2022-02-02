class Goal < ApplicationRecord
  validates :title, :user_id, presence: true

  belongs_to :user

  def toggle_completed
    self.completed = !self.completed
    self.save
  end

  def private_goal?
    self.private
  end
end