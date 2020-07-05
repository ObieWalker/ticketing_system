class Request < ApplicationRecord
    has_many :comments
    belongs_to :user
    enum status: %i[unresponded opened closed]
    attribute :status, :integer, default: 0

end
