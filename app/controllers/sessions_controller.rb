class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:create], :raise => false

  def new
    render json: { message: "User Authenticated"}, status: :ok
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      render json: { message: "User Authenticated"}, status: :ok
    else
      render json: { message: "Email or password incorrect"}, status: :not_found
    end
  end

  def login
  end

  def welcome
  end

  private

  def user_params
    params
    .require(:user)
    .permit(:email, :password)
  end
end
