class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, :session_token, uniqueness: true

  def self.generate_token
    
  end
end