class UserAuthentication < ApplicationRecord
  has_secure_password
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :email
  validates_presence_of :password_digest

  def self.generate_token_params
    {
      token: SecureRandom.uuid.delete('-'),
      token_expire_date: DateTime.now + Globals::EMAIL_AUTH_TOKEN_EXPIRE_PERIOD
    }
  end

end
