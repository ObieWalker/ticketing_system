require 'rails_helper'

RSpec.describe "Requests", type: :request do
  context 'GET #requests' do
    it "gets first 10 requests based on param status" do
      @user1 = create(:user, role: 1)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)
      
      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      get "/requests?status=0", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "gets requests based on search" do
      @user1 = create(:user, role: 1)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)
      search_term = @request1.request_title[0,2]

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      get "/requests?status=0&q=#{search_term}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to requests as a customer" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      get "/requests?status=0", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'CREATE #requests' do
    it "creates a request" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      request_params = {
        :request => {
          :request_title => Faker::Lorem.word,
          :request_body => Faker::Lorem.sentence
        }
      }
      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      post "/requests", :params => request_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
  end

  context 'GET a #request' do
    it "returns a request for an agent" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      @user2 = create(:user, role: 1)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      get "/requests/#{@request1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "returns a request for a customer" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      get "/requests/#{@request1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails request for a customer" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      get "/requests/#{@request1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'UPDATE #request' do
    it "fails to update a request" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      put "/requests/#{@request1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end

    it "updates a request to closed" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      @user2 = create(:user, role: 1)
      @user_auth2 = create(:user_authentication, user: @user2)

      request_params = {
        :request => {
          :status => 0
        }
      }
      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      put "/requests/#{@request1.id}", :params => request_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "assigns an agent to a request" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      @user2 = create(:user, role: 1)
      @user_auth2 = create(:user_authentication, user: @user2)

      request_params = {
        :request => {
          :status => 2,
          :agent_assigned => @user2.id
        }
      }
      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      put "/requests/#{@request1.id}", :params => request_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "unassigns an agent to a request" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      @user2 = create(:user, role: 1)
      @user_auth2 = create(:user_authentication, user: @user2)

      request_params = {
        :request => {
          :agent_assigned => ""
        }
      }
      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      put "/requests/#{@request1.id}", :params => request_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

  end
end
