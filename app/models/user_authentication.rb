class UserAuthentication < ApplicationRecord
  has_secure_password

  belongs_to :user

  def token_expired?
    token_expire_date < DateTime.now
  end

  def self.generate_token_params
    {
      token: SecureRandom.uuid.delete('-'),
      token_expire_date: DateTime.now + Globals::EMAIL_AUTH_TOKEN_EXPIRE_PERIOD
    }
  end

end
