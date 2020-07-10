class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :request

    validates_presence_of :user
    validates_presence_of :request
    validates_presence_of :comment

end
