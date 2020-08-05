class SessionSerializer
  include FastJsonapi::ObjectSerializer

  set_id :id
  attributes :token, :token_expire_date, :user_id, :email

  attribute :username do |object|
    "#{User.find(object.user_id).username}"
  end

  attribute :role do |object|
    "#{User.find(object.user_id).role}"
  end
end
