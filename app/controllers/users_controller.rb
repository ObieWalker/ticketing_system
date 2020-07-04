class UsersController < ApplicationController
  skip_before_action :authorize, only: [:create], :raise => false

  def create
    @user = User.create(user_params)
    if @user
      session[:user_id] = @user.id
      render json: { message: "User Created"}, status: :created
      return
    end
    render :json => error_payload, :status => :bad_request
  end

  private

  def user_params
    params
    .require(:user)
    .permit(:username, :email, :password)
  end
  
  def error_payload
    {
      error: "No such user; check the submitted email address",
      status: 400
    }
  end
end
