require 'rails_helper'

RSpec.describe Request, type: :model do

  subject {
    user = User.create(:username => "testuser", :email => 'testuser@gmail.com')

    described_class.new(user_id: user.id,
                        request_title: "Issues with my laptop screen",
                        request_body: "Can I bring my laptop for repairs?")
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
      subject.request_title = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid without a comment' do
      subject.request_body = nil
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
  end
end