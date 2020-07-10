class Request < ApplicationRecord
    has_many :comments, dependent: :destroy
    belongs_to :user
    validates_presence_of :user
    validates_presence_of :request_title
    validates_presence_of :request_body
    enum status: %i[unresponded opened closed]
    attribute :status, :integer, default: 0

end
