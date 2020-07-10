FactoryBot.define do
  
  factory :session do
    email { Faker::Internet.email }
    password { BCrypt::Password.create(Faker::Lorem.word) }
  end
end