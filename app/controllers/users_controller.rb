class UsersController < ApplicationController
  before_action :authenticate, except: [:create]
  before_action :admin_auth, only: [:update, :destroy]

  def index
    if user_search?
      users = User.paginate(page: params[:page], per_page: 5)
      json_response(UserSerializer.new(users, set_total(users)))
    else
      users = User.ransack(username_or_email_cont: params[:q]).result.paginate(page: params[:page], per_page: 5)
      json_response(UserSerializer.new(users, set_total(users)))
    end
  end

  def create
    if unique_email?
      json_response(SessionSerializer.new(create_user), status = :created)
    else
      json_response({message: "Account already exists"}, status = :bad_request)
    end
  rescue StandardError => e
    json_response({message: "There was an error signing up."}, status = :bad_request)
  end

  def show
    unless current_user.nil?
      json_response(SessionSerializer.new(current_user.user_authentication))
    else
      json_response({message: "Unable to get user"}, status = :bad_request)
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

  def create_user
    user = 
    ActiveRecord::Base.transaction do
      user = User.create!(user_params)
      auth_params(user)
    end
    user
  end

  def auth_params(user)
    token_params = UserAuthentication.generate_token_params
    auth_values = signup_params.merge(user_id: user.id)
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

  def set_total(users)
    options = {}
    options[:meta] = {total: users.total_entries}
    options
  end
end
