require 'rails_helper'

RSpec.describe "Comments", type: :request do
  context 'POST #comments' do
    it "creates a new comment" do
      @user1 = create(:user, role: 1)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      comment_params = {
        :comment => {
          :request_id => @request1.id,
          :comment => Faker::Lorem.sentence 
        }
      }

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      post "/comments", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:created)
    end

    it "fails to create a new comment" do
      @user1 = create(:user)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      comment_params = {
        :comment => {
          :request_id => @request1.id,
          :comment => Faker::Lorem.sentence 
        }
      }
      
      headers = { "ACCEPT" => "application/json" }
      post "/comments", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end

    it "fails to create a new comment" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      comment_params = {
        :comment => {}
      }
      
      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      post "/comments", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:bad_request)
    end

    it "creates a new comment as a customer" do

      #a customer creates a request
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      #an agent makes a comment so a customer can make one
      @user2 = create(:user, role: 1)
      @user_auth2 = create(:user_authentication, user: @user2)
      @comment1 = create(:comment, user: @user2, request: @request1)

      comment_params = {
        :comment => {
          :request_id => @request1.id,
          :comment => Faker::Lorem.sentence 
        }
      }
      
      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      post "/comments", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:created)
    end

    it "restricts creating a new comment as a customer before an agent" do

      #a customer creates a request
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)

      comment_params = {
        :comment => {
          :request_id => @request1.id,
          :comment => Faker::Lorem.sentence 
        }
      }
      
      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      post "/comments", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'PUT #comments' do
    it "updates a comment" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)
      @comment1 = create(:comment, user: @user1, request: @request1)

      comment_params = {
        :comment => {
          :request_id => @request1.id,
          :comment => Faker::Lorem.sentence 
        }
      }

      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      put "/comments/#{@comment1.id}", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to update a comment" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)
      @request1 = create(:request, user: @user1)
      @comment1 = create(:comment, user: @user1, request: @request1)

      comment_params = {
        :comment => {
          :request_id => @request1.id,
          :comment => Faker::Lorem.sentence 
        }
      }

      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      put "/comments/#{@comment1.id}", :params => comment_params, :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'DELETE #comments' do
    it "deletes a comment" do
      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      @request1 = create(:request, user: @user1)
      @comment1 = create(:comment, user: @user1, request: @request1)


      headers = { "ACCEPT" => "application/json", "token" => @user_auth1.token }
      delete "/comments/#{@comment1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end

    it "fails to delete a comment" do

      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      #a user cannot delete a comment that they did not make unless they are admin/agent
      @user2 = create(:user, role: 2)
      @user_auth2 = create(:user_authentication, user: @user2)
      @request1 = create(:request, user: @user1)
      @comment1 = create(:comment, user: @user1, request: @request1)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      delete "/comments/#{@comment1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end

    it "agent deletes a comment" do

      @user1 = create(:user, role: 2)
      @user_auth1 = create(:user_authentication, user: @user1)
      #a user cannot delete a comment that they did not make unless they are admin/agent
      @user2 = create(:user, role: 1)
      @user_auth2 = create(:user_authentication, user: @user2)
      @request1 = create(:request, user: @user1)
      @comment1 = create(:comment, user: @user1, request: @request1)

      headers = { "ACCEPT" => "application/json", "token" => @user_auth2.token }
      delete "/comments/#{@comment1.id}", :headers => headers

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
  end
end
