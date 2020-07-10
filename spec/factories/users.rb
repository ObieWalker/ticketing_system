FactoryBot.define do
  
  factory :user do
    username { Faker::Name.name  }
    email { Faker::Internet.email }
    role { Faker::Number.between(from: 0, to: 2) }
  end
  factory :user_authentication do
    user factory: :user
    email { user.email }
    password_digest { BCrypt::Password.create(Faker::Lorem.word) }
    token { SecureRandom.uuid.delete('-') }
    token_expire_date { DateTime.now + Globals::EMAIL_AUTH_TOKEN_EXPIRE_PERIOD }
  end
  factory :request do
    user factory: :user
    request_title { Faker::Lorem.word  }
    request_body { Faker::Lorem.sentence  }
    status { 0 }
    closed_date {nil}
    agent_assigned {nil}
  end
  factory :comment do
    user factory: :user
    request factory: :request
    comment { Faker::Lorem.sentence  }
  end
end