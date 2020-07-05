class User < ApplicationRecord
    has_secure_password
    has_many :requests
    has_many :comments
    enum status: %i[admin agent customer]
end
