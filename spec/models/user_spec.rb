require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(email: "test_user@gmail.com",
                        username: "test_user")
  }
  context 'validation tests' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it 'is invalid without a username' do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'should save successfully' do
      user = User.new(username: 'test_user', email: 'test_user@gmail.com').save
      expect(user).to eq(true)
    end
  end

  context 'scope tests' do

  end

  describe "Associations" do
    it { should have_many(:requests) }
    it { should have_many(:comments) }
    it { should have_one(:user_authentication) }
  end
end