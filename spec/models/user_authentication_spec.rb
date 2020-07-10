require 'rails_helper'

RSpec.describe UserAuthentication, type: :model do

  subject {
    user = User.create(:username => "testuser", :email => 'testuser@gmail.com')

    described_class.new(user_id: user.id,
                        email: "test_user@gmail.com",
                        password: "testpassword")
  }
  context 'validation tests' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it 'is invalid without a user_id' do
      subject.user = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid without a email' do
      subject.email = nil
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