class ApplicationController < ActionController::API
  include Pundit

  rescue_from Pundit::NotAuthorizedError do
    render json: {
      message: "You are not authorized to carry out this action."
      }, status: :unauthorized
  end


  def current_user
    u = UserAuthentication.find_by_token(request.headers["token"])
    u.user
  end

  def authenticate
    token = request.headers["token"]
    unless token.present? && UserAuthentication.find_by_token(token)
      render json: {message: "Please Login."}, status: :unauthorized
      return
    end
  end

  def logged_in?
    !current_user.nil?  
  end

  def admin_auth
    unless current_user.role == 0
      render json: {message: "Unauthorized action"}, status: :unauthorized
      return
    end
  end

  def authorize_user
    unless logged_in?
      render json: { message: "Unauthorized"}, status: :unauthorized
      return
    end
  end

  def agent_auth
    unless current_user.role == 0 || 1
      render json: {message: "Unauthorized action"}, status: :unauthorized
      return
    end
  end

  def authorize_comment
    if current_user.role == 2 && Comment.where(request_id: params[:comment]["request_id"]).empty?
      render json: {message: "Unauthorized action"}, status: :unauthorized
      return
    end
  end
end
