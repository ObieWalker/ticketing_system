require 'rails_helper'

RSpec.describe Comment, type: :model do
  # describe ".comment!" do
  #   it "create a new comment on a request" do
  #     user = User.create(:username => "testuser", :email => 'testuser@gmail.com', :password => 'pw1234' )
  #     request = Request.create(
  #       :user_id => user.id,
  #       :request_title => 'Problems are brewing',
  #       :request_body => 'There are problems brewing and I want an answer.' )

  #     comment = Comment.create(user_id: user.id, request_id: request.id, comment: "A test comment.")

  #     subject {
  #       described_class.new(user_id: user.id,
  #                           request_id: request.id,
  #                           comment: "Test comment")
  #     }
  #   end
  # end


  # let(:user) {
  #   User.new(:username => "firstuser", :email => "first_user@gmail.com")
  # }

  # let(:request) {
  #   Request.new(
  #     :user_id => "firstuser",
  #     :request_title => "Some Issues",
  #     :request_body => "Can I be given a solution")
  # }

  subject {
    user = User.create(:username => "testuser", :email => 'testuser@gmail.com')
    request = Request.create(
      :user_id => user.id,
      :request_title => 'Problems are brewing',
      :request_body => 'There are problems brewing and I want an answer.'
      )

    described_class.new(user_id: user.id,
                        request_id: request.id,
                        comment: "Test comment")
  }
  context 'validation tests' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it 'is invalid without a user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid without a request_id' do
      subject.request_id = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid without a comment' do
      subject.comment = nil
      expect(subject).to_not be_valid
    end

    # it 'should save successfully' do
    #   user = User.new(username: 'test_user', email: 'test_user@gmail.com').save
    #   expect(user).to eq(true)
    # end
  end

  context 'scope tests' do

  end

  describe "Associations" do
    it { should belong_to(:user).without_validating_presence }
    it { should belong_to(:request).without_validating_presence }

  end
end