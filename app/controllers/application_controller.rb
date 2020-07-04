class ApplicationController < ActionController::API
  def current_user    
      User.find_by(id: session[:user_id])  
  end

  def logged_in?
    !current_user.nil?  
  end

  def authorize
    unless logged_in?
      render json: { message: "Unauthorized"}, status: :unauthorized
      return
    end
  end
end
