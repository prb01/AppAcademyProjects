class User < ApplicationRecord
  include BCrypt

  validates :email, :password_digest, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :email, :session_token, uniqueness: true
  before_validation :ensure_session_token

  has_many :subs, foreign_key: :moderator_id
  has_many :posts, foreign_key: :author_id
  has_many :comments, foreign_key: :author_id

  attr_reader :password

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return user if user && user.is_password?(password)
    nil
  end

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= User.generate_token
  end

  def reset_session_token
    self.session_token = User.generate_token
    self.save
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = Password.create(password)
  end

  def is_password?(password)
    Password.new(self.password_digest) == password
  end
end