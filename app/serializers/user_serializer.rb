class UserSerializer
  include FastJsonapi::ObjectSerializer

  set_id :id
  attributes :username, :email, :role
end
