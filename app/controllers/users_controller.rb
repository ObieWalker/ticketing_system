class UsersController < ApplicationController
  before_action :authenticate, except: [:create]
  before_action :admin_auth, only: [:update, :destroy]

  def index
    if user_search?
      users = User.paginate(page: params[:page], per_page: 10)
      json_response(UserSerializer.new(users))
    else
      users = User.ransack(username_or_email_cont: params[:q]).result.first(5)
      json_response(UserSerializer.new(users))
    end
  end

  def create
    if unique_email?
      @user = User.create(user_params)
      if @user && auth_params
        json_response({ message: "User Created", token: auth_params.token}, status = :created)
        return
      end
      json_response({error: "There was an error signing up."}, status = :bad_request)
    else
      json_response({message: "Account already exists"}, status = :bad_request)
    end
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(role: update_params[:role])
      json_response({ message: "User has been updated"})
    else
      json_response({ message: "User cannot be updated"}, status = :bad_request)
    end
  end

  def destroy
    if User.destroy(params[:id])
      json_response({ message: "User has been deleted"})
    else
      json_response({ message: "Unable to delete user"}, status = :bad_request)
    end
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

  def unique_email?
    !User.find_by_email(user_params[:email].downcase)
  end

  def user_search?
    params[:q].nil?
  end
end
