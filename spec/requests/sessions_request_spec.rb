require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  context 'POST #sessions' do
    it "creates a new session" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication, password_digest: BCrypt::Password.create("password123"))
      session_params = {
        :user => {
          :email => @user_auth1.email,
          :password => "password123"
        }
      }
      
      headers = { "ACCEPT" => "application/json" }
      post "/sessions", :params => session_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to create a new session" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication, password_digest: BCrypt::Password.create("password123"))
      session_params = {
        :user => {
          :email => @user_auth1.email,
          :password => "password12"
        }
      }
      
      headers = { "ACCEPT" => "application/json" }
      post "/sessions", :params => session_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'DESTROY #sessions' do
    it "deletes a session" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication)
      
      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      delete "/sessions/#{@user1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to delete a session" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication, user: @user1)
      
      headers = { "ACCEPT" => "application/json", "token" => "" }
      delete "/sessions/#{@user1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
