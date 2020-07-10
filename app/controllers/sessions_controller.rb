class SessionsController < ApplicationController
  before_action :authenticate, except: [:create]

  def create
    user = UserAuthentication.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      user.update(UserAuthentication.generate_token_params)
      json_response({ message: "User Authenticated", token: user.token })
    else
      json_response({ message: "Email or password incorrect"}, status = :not_found)
    end
  end

  def destroy
    if current_user.try(:user_authentication)
      current_user.user_authentication.update(
        token: nil, token_expire_date: nil
      )
      json_response({ message: "User logged out."})
    else
      json_response({ message: "Unable to log you out."}, status = :unauthorized)
    end
  end


  private

  def user_params
    params
    .require(:user)
    .permit(:email, :password, :id)
  end
end
