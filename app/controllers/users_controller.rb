class UsersController < ApplicationController
  before_action :authenticate, except: :create
  before_action :admin_auth, only: [:update, :destroy]
  skip_before_action :authorize, only: [:create], :raise => false

  def index
    if user_search?
      users = User.paginate(page: params[:page], per_page: 10)
      render json: UserSerializer.new(users)
    else
      users = User.ransack(username_or_email_cont: params[:q]).result.first(5)
      render json: UserSerializer.new(users)
    end
  end

  def create
    if unique_email?
      @user = User.create(user_params)
      if @user && auth_params
        session[:user_id] = @user.id
        render json: { message: "User Created", token: @user.user_authentication.token}, status: :created
        return
      end
      render :json => error_payload, :status => :bad_request
    else
      render json: { message: "Account already exists"}, status: :bad_request
    end
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(role: update_params[:role])
      render json: { message: "User has been updated"}, status: :ok
    else
      render json: { message: "User cannot be updated"}, status: :bad_request
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { message: "User has been deleted"}, status: :ok
      return
    end
    render json: { message: "Unable to delete user"}, status: :bad_request

  end

  private

  def user_params
    params
    .require(:user)
    .permit(:username, :email)
  end

  def signup_params
    params
    .require(:user)
    .permit(:email, :password)
  end

  def auth_params
    token_params = UserAuthentication.generate_token_params
    auth_values = signup_params.merge(user_id: @user.id)
    auth_values = auth_values.merge(token_params)
    UserAuthentication.create(auth_values)
  end

  def update_params
    params
    .permit(:id, :role)
  end
  
  def error_payload
    {
      error: "There was an error signing up.",
      status: 400
    }
  end

  def unique_email?
    !User.find_by_email(user_params[:email].downcase)
  end

  def user_search?
    params[:q].nil?
  end
end
