require 'rails_helper'

RSpec.describe "Users", type: :request do

  context 'POST #create' do
    it "creates a new user" do
      headers = { "ACCEPT" => "application/json" }
      post "/users", :params => { :user => {:username => "dakoreUser", :email => "testuser@gmail.com"} }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:created)
    end

    it "fails to create a new user" do

      headers = { "ACCEPT" => "application/json" }
      post "/users", :params => { :user => {:username => "testuser", :email => "testuser@gmail.com"} }, :headers => headers
      post "/users", :params => { :user => {:username => "dakoreUser", :email => "testuser@gmail.com"} }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'GET #index' do
    it "fails to authenticate user" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication)

      headers = { "ACCEPT" => "application/json", "token" => ""}
      get "/users", :params => { :page => 1 }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end

    it "gets first five users" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      get "/users", :params => { :page => 1 }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "searches for  user" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      get "/users", :params => { :q => "l" }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
  end
  
  context 'PUT #update' do
    it "updates a user role" do
      @user1 = create(:user, role: 0)
      @user_auth1 = create(:user_authentication, user: @user1)

      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      put "/users/#{@user2.id}", :params => { :role => 1 }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to update a user" do
      @user1 = create(:user, role: 1)
      @user_auth1 = create(:user_authentication, user: @user1)

      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      put "/users/#{@user2.id}", :params => { :role => 1 }, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'DELETE #destroy' do
    it "deletes a user" do
      @user1 = create(:user, role: 0)
      @user_auth1 = create(:user_authentication, user: @user1)

      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }

      delete "/users/#{@user2.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to delete a user" do
      @user1 = create(:user, role: 1)
      @user_auth1 = create(:user_authentication, user: @user1)

      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }

      delete "/users/#{@user2.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
