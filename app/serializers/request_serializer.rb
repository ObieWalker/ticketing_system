class RequestSerializer
  include FastJsonapi::ObjectSerializer

  set_id :id
  attributes :request_body, :request_title, :status, :user_id, :agent_assigned, :created_at


  attribute :username do |object|
    "#{User.find(object.user_id).username}"
  end

  attribute :agent_name do |object|
    object.agent_assigned ?
    "#{User.find(object.agent_assigned).username}":
    ""
  end
end
  