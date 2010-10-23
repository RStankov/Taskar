require 'spec_helper'
require 'digest/sha1'

describe Invitation do
  it_should_allow_mass_assignment_only_of :email, :first_name, :last_name, :message

  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { Factory(:invitation).should validate_uniqueness_of(:email).scoped_to(:account_id) }
  it { should_not allow_value('not valid address').for(:email) }
  it { should_not allow_value('domain.com').for(:email) }
  it { should_not allow_value('some@domain').for(:email) }
  it { should allow_value('some@domain.com').for(:email) }

  it "should not allow user who already is in this account to be added twice" do
    account_user = Factory(:account_user)
    invitation   = Factory.build(:invitation, :account => account_user.account, :email => account_user.user.email)

    invitation.save.should be_false
    invitation.should have(1).error_on(:email)
    invitation.errors[:email].first.should == I18n.t("activerecord.errors.invitations.account_exists")
  end

  describe "#full_name" do
    it "should be first_name + last_name" do
      invitation = Factory.build(:invitation, {:first_name => 'Radoslav', :last_name => 'Stankov'})
      invitation.full_name.should == "Radoslav Stankov"
    end
  end

  describe "#generate_token" do
    it "should be genereated of sha1 of [invitation-token-{Time.now}-{email}-{rand(100)}]" do
      invate = Factory.build(:invitation)
      invate.stub(:rand).with(100).and_return 5
      invate.save.should be_true
      invate.should_not be_new_record
      invate.token.should == Digest::SHA1.hexdigest("[invitation-token-#{Time.now}-#{invate.email}-5]")
    end
  end

  describe "#user" do
    it "should return a user with same e-mail as the invitation e-mail" do
      invitation = Factory(:invitation, :email => "same@email34343.com")
      user = Factory(:user, :email => invitation.email)

      invitation.user.should == user
    end

    it "should memorize it's value" do
      invitation = Factory(:invitation)
      invitation.user.first_name = "some name"
      invitation.user.first_name.should == "some name"
      invitation.user.last_name = "other name"
      invitation.user.last_name.should == "other name"
      invitation.user.full_name == "some name other name"
    end

    it "should return new user if user with invitation e-mail doesn't exits" do
      invitation = Factory(:invitation)
      invitation.user.should be_new_record
    end

    it "should pre populate new user with inviations email, first_name, last_name" do
      invitation = Factory(:invitation, :first_name => "inviation.first_name", :last_name => "inviation.last_name")
      invitation.user.email.should == invitation.email
      invitation.user.first_name.should == "inviation.first_name"
      invitation.user.last_name.should  == "inviation.last_name"
    end
  end

  describe "#create_user" do
    it "should use Invitation#user method" do
      invitation = Factory(:invitation)
      invitation.should_receive(:user).at_least(1).times.and_return User.new
      invitation.create_user
    end

    it "should accept hash of :password, :password_confirmation, :locale, :avatar" do
      invitation = Factory(:invitation)

      invitation.create_user(:first_name => "no first", :last_name => "no last", :password => "password", :password_confirmation => "password_confirmation", :locale => "locale", :avatar => "avatar")
      invitation.user.password.should == "password"
      invitation.user.password_confirmation.should == "password_confirmation"
      invitation.user.locale.should == "locale"
      invitation.user.first_name.should_not == "no first"
      invitation.user.last_name.should_not == "no last"
    end

    it "should return false if user is invalid" do
      invitation = Factory(:invitation)
      invitation.stub(:user).and_return user = Factory.build(:user)
      user.should_receive(:save).and_return false

      invitation.create_user.should be_false
    end

    it "should return false if user is existing user" do
       invitation = Factory(:invitation)
       invitation.stub(:user).and_return user = Factory(:user)

       invitation.create_user.should be_false
    end

    it "should return true if user is created succesfully" do
      invitation = Factory(:invitation)

      invitation.user.should be_new_record
      invitation.create_user(Factory.attributes_for(:user)).should be_true
      invitation.user.should_not be_new_record
    end

    it "should connect newly created user with invitation account" do
      invitation = Factory(:invitation)
      invitation.create_user(Factory.attributes_for(:user)).should be_true

      AccountUser.find_by_account_id_and_user_id(invitation.account_id, invitation.user.id).should_not be_nil
    end

    it "should delete this invitation if user attributes are valid" do
      invitation = Factory(:invitation)

      invitation.create_user.should be_false
      invitation.should_not be_destroyed

      invitation.create_user(Factory.attributes_for(:user)).should be_true
      invitation.should be_destroyed
    end
  end
end
