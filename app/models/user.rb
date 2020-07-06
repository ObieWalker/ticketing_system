class User < ApplicationRecord
  has_many :requests, dependent: :destroy
  has_many :comments
  has_one :user_authentication, dependent: :destroy
  enum status: %i[admin agent customer]
end
