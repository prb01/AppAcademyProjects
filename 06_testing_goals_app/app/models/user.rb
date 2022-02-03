require 'bcrypt'

class User < ApplicationRecord
  include Commentable
  
  validates :email, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :email, :session_token, uniqueness: true
  before_validation :ensure_session_token

  has_many :goals, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :authored_comments,
    class_name: 'Comment',
    primary_key: :id,
    foreign_key: :author_id,
    dependent: :destroy

  attr_reader :password

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return user if user && user.is_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(@password)
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save
    self.session_token
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end
end