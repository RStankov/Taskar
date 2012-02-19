require 'spec_helper'
require 'digest/sha1'

describe Invitation do
  it_should_allow_mass_assignment_only_of :email, :first_name, :last_name, :message

  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }

  it { create(:invitation).should validate_uniqueness_of(:email).scoped_to(:account_id) }

  it { should_not allow_value('not valid address').for(:email) }
  it { should_not allow_value('example.com').for(:email) }
  it { should_not allow_value('rs@example').for(:email) }
  it { should allow_value('rs@example.org').for(:email) }

  it "not allowing user, who is already in this account to be added" do
    account_user = create(:account_user)
    invitation   = build(:invitation, :account => account_user.account, :email => account_user.user.email)

    invitation.save.should be_false
    invitation.should have(1).error_on(:email)
    invitation.errors[:email].first.should eq 'is already registered in your account'
  end

  it "can tell its receiver name" do
    invitation = build :invitation, :first_name => 'Radoslav', :last_name => 'Stankov'
    invitation.receiver_name.should eq 'Radoslav Stankov'
  end

  it "can tell from who is its sender" do
    account    = build(:account)
    invitation = build :invitation, :account => account

    invitation.sender_name.should eq account.owner.full_name
  end

  it "generates token on creation" do
    invate = create :invitation
    invate.token.should be_present
  end

  describe "user" do
    it "returns a user with same e-mail as the invitation e-mail" do
      email      = 'rs@example.org'
      invitation = create :invitation, :email => email
      user       = create :user, :email => invitation.email

      invitation.user.should eq user
    end

    it "returns new user if user with invitation e-mail doesn't exits" do
      invitation = create :invitation
      invitation.user.should be_new_record
    end

    it "populates new user with inviations email, first_name, last_name" do
      invitation = create :invitation, :first_name => 'Radoslav', :last_name => 'Stankov'

      invitation.user.email.should eq invitation.email
      invitation.user.first_name.should eq 'Radoslav'
      invitation.user.last_name.should  eq 'Stankov'
    end
  end

  describe "accept" do
    let(:invitation) { create :invitation }

    context "new user" do
      def valid_user_attributes
        attributes_for(:user)
      end

      it "accepts attributes for its user" do
        invitation.accept(:first_name => 'Radoslav', :last_name => 'Stankov', :password => 'password', :password_confirmation => 'password_confirmation', :avatar => 'avatar')

        user = invitation.user
        user.password.should eq 'password'
        user.password_confirmation.should eq 'password_confirmation'
        user.first_name.should_not eq 'Radoslav'
        user.last_name.should_not eq 'Stankov'
      end

      it "returns false if user is invalid" do
        invitation.accept.should be_false
        invitation.user.should_not be_valid
      end

      it "returns true if user is created succesfully" do
        invitation.accept valid_user_attributes
        invitation.user.should_not be_new_record
      end

      it "deletes this invitation after succesfull accepting" do
        invitation.accept
        invitation.should_not be_destroyed

        invitation.accept valid_user_attributes
        invitation.should be_destroyed
      end

      it "connects newly created user with invitation account" do
        invitation.accept valid_user_attributes

        AccountUser.find_by_account_id_and_user_id(invitation.account_id, invitation.user.id).should be_present
      end
    end

    context "existing user" do
      def password
        '123456'
      end

      before do
        create :user, :email => invitation.email, :password => password, :password_confirmation => password
      end

      it "returns false if user is existing user, and password is invalid" do
        invitation.accept.should be_false
        invitation.accept(:password => 'wrong').should be_false
      end

      it "returns true if user is existing, and password is valid" do
        invitation.accept(:password => password).should be_true
      end

      it "connects the existing user with invitation account" do
        invitation.accept :password => password

        AccountUser.find_by_account_id_and_user_id(invitation.account_id, invitation.user.id).should be_present
      end
    end
  end
end
