class ApplicationController < ActionController::API
  include Pundit
  include Response
  include ExceptionHandler

  rescue_from Pundit::NotAuthorizedError do
    json_response(
      {
        message: "You are not authorized to carry out this action."
      },
      status = :unauthorized
    )
  end

  def current_user
    UserAuthentication.find_by_token(request.headers["token"]).try(:user)
  end

  def authenticate
    token = request.headers["token"]

    token_exists = UserAuthentication.find_by_token(token) if token.present?
    if token_exists.nil? || token_exists.token_expired?
      json_response({message: "Please Login."}, status = :unauthorized)
      return
    end
  end

  def admin_auth
    unless current_user.role == 0
      json_response({message: "Unauthorized action."}, status = :unauthorized)
      return
    end
  end

  def agent_auth
    if current_user.role == 2
      json_response({message: "Unauthorized action."}, status = :unauthorized)
      return
    end
  end
end
