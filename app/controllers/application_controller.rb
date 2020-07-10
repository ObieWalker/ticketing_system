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
    unless token.present? && UserAuthentication.find_by_token(token)
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

  def authorize_comment
    first_request_comment = Comment.where(request_id: params[:comment]["request_id"]).empty?
    if current_user.role == 2 && first_request_comment
      json_response({message: "Unauthorized action."}, status = :unauthorized)
      return
    end
  end

  def check_comment_params
    if params[:comment].nil? || params[:comment]["request_id"].nil? || params[:comment]["comment"].nil?
      json_response({message: "Check user parameters."}, status = :bad_request)
      return
    end
  end
end
