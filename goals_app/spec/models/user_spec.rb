require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }

    it { should validate_length_of(:password).is_at_least(6) }

    before(:each) { FactoryBot.create(:user, email: "test@test.com") }

    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:session_token) }
  end

  describe "methods" do
    context "::find_by_credentials" do
      let(:u) { FactoryBot.create(:user) }

      it "should return user when valid credentials" do
        expect(User.find_by_credentials(u.email, u.password)).to eq(u)
      end

      it "should return nil when invalid credentials" do
        expect(User.find_by_credentials(u.email, "bla")).to be_nil
      end
    end

    context "#reset_session_token!" do
      it "should generate a new session token" do
        old_token = user.session_token
        user.reset_session_token!
        expect(user.reset_session_token!).not_to eq(old_token)
      end

      it "should save new session token" do
        user.reset_session_token!
        token = User.find_by(email: user.email).session_token
        expect(user.session_token).to eq(token)
      end
    end

    context "#ensure_session_token" do
      it "should keep current session token if available" do
        u = FactoryBot.build(:user, session_token: "ALREADYHERE")
        token = u.session_token
        u.ensure_session_token
        expect(u.session_token).to eq(token)
      end

      it "should generate new session token if nil" do
        expect(user.session_token).to be_nil
        user.ensure_session_token
        expect(user.session_token).not_to be_nil
      end
    end
  end

  describe "associations" do
  end
end
