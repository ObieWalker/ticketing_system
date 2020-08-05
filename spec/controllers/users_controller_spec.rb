require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'POST #create' do
    before(:each) do
      user = User.new(username: 'same_user', email: 'same@gmail.com').save
    end
    it 'returns a bad request response' do
      post :create, :params => { :user => { :username => 'same_user', :email => 'same@gmail.com'}, :format => :json }
      expect(response.message).to eq "Bad Request"
      expect(response.status).to eq 400
    end
    it 'returns a created response' do
      post :create, :params => { :user => { :username => 'different_user', :email => 'different@gmail.com'}, :format => :json }
      expect(response.message).to eq "Created"
      expect(response.status).to eq 201
    end
  end
end