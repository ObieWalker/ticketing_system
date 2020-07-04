class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:create], :raise => false

  def new
    render json: { message: "User Authenticated"}, status: :ok
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      sessions[:user_id] = @user.id
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


end
