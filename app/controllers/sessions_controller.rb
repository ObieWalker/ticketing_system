class SessionsController < ApplicationController
  skip_before_action :authorize_user, only: [:create], :raise => false

  def create
    user = UserAuthentication.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      user.update(UserAuthentication.generate_token_params)
      render json: { message: "User Authenticated", token: user.token }, status: :ok
    else
      render json: { message: "Email or password incorrect"}, status: :not_found
    end
  end

  def destroy
    current_user.user_authentication.update(token: nil, token_expire_date: nil)
    render json: { message: "User logged out successfully"}, status: :ok
  end


  private

  def user_params
    params
    .require(:user)
    .permit(:email, :password, :id)
  end
end
