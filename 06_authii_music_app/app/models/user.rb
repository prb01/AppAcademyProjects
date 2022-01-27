class User < ApplicationRecord
  validates :email, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :email, :session_token, uniqueness: true
  after_initialize :ensure_session_token, :ensure_activation_token

  has_many :notes

  attr_reader :password

  def self.generate_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(user_params)
    user = User.find_by(email: user_params[:email])
    return user if user && user.is_password?(user_params[:password])
    nil
  end

  def reset_session_token!
    self.session_token = User.generate_token
    self.save
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_token
  end

  def ensure_activation_token
    self.activation_token = User.generate_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end