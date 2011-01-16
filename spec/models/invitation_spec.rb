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

  it "not allowing user, who is already in this account to be added" do
    account_user = Factory(:account_user)
    invitation   = Factory.build(:invitation, :account => account_user.account, :email => account_user.user.email)

    invitation.save.should be_false
    invitation.should have(1).error_on(:email)
    invitation.errors[:email].first.should == I18n.t("activerecord.errors.invitations.account_exists")
  end

  it "provides user's full_name" do
    invitation = Factory.build(:invitation, {:first_name => 'Radoslav', :last_name => 'Stankov'})
    invitation.full_name.should == "Radoslav Stankov"
  end

  it "generates token" do
    invate = Factory.build(:invitation)
    invate.stub(:rand).with(100).and_return 5
    invate.save.should be_true
    invate.should_not be_new_record
    invate.token.should == Digest::SHA1.hexdigest("[invitation-token-#{Time.now}-#{invate.email}-5]")
  end

  describe "#user" do
    it "returns a user with same e-mail as the invitation e-mail" do
      invitation = Factory(:invitation, :email => "same@email34343.com")
      user = Factory(:user, :email => invitation.email)

      invitation.user.should == user
    end

    it "memorizes it's value" do
      invitation = Factory(:invitation)
      invitation.user.first_name = "some name"
      invitation.user.first_name.should == "some name"
      invitation.user.last_name = "other name"
      invitation.user.last_name.should == "other name"
      invitation.user.full_name == "some name other name"
    end

    it "returns new user if user with invitation e-mail doesn't exits" do
      invitation = Factory(:invitation)
      invitation.user.should be_new_record
    end

    it "pre populates new user with inviations email, first_name, last_name" do
      invitation = Factory(:invitation, :first_name => "inviation.first_name", :last_name => "inviation.last_name")
      invitation.user.email.should == invitation.email
      invitation.user.first_name.should == "inviation.first_name"
      invitation.user.last_name.should  == "inviation.last_name"
    end
  end

  describe "#accept" do
    it "uses Invitation#user method" do
      invitation = Factory(:invitation)
      invitation.should_receive(:user).at_least(1).times.and_return User.new
      invitation.accept({})
    end

    it "accepts hash of :password, :password_confirmation, :locale, :avatar (for new_user)" do
      invitation = Factory(:invitation)

      invitation.accept(:first_name => "no first", :last_name => "no last", :password => "password", :password_confirmation => "password_confirmation", :locale => "locale", :avatar => "avatar")
      invitation.user.password.should == "password"
      invitation.user.password_confirmation.should == "password_confirmation"
      invitation.user.locale.should == "locale"
      invitation.user.first_name.should_not == "no first"
      invitation.user.last_name.should_not == "no last"
    end

    it "returns false if user is invalid" do
      invitation = Factory(:invitation)
      invitation.stub(:user).and_return user = Factory.build(:user)
      user.should_receive(:save).and_return false

      invitation.accept({}).should be_false
    end

    it "returns true if user is created succesfully" do
      invitation = Factory(:invitation)

      invitation.user.should be_new_record
      invitation.accept(Factory.attributes_for(:user)).should be_true
      invitation.user.should_not be_new_record
    end

    it "returns false if user is existing user, and password is invalid" do
       invitation = Factory(:invitation)
       invitation.stub(:user).and_return user = Factory(:user)

       invitation.accept({}).should be_false
       invitation.accept(:password => 23242).should be_false
    end

    it "returns true if user is existing, and password is valid" do
      invitation = Factory(:invitation)
      invitation.stub(:user).and_return user = Factory(:user)

      user.should_receive(:valid_password?).with("valid").and_return true

      invitation.accept(:password => "valid").should be_true
    end

    it "connects newly created user with invitation account" do
      invitation = Factory(:invitation)
      invitation.accept(Factory.attributes_for(:user)).should be_true

      AccountUser.find_by_account_id_and_user_id(invitation.account_id, invitation.user.id).should_not be_nil
    end

    it "deletes this invitation if user attributes are valid" do
      invitation = Factory(:invitation)

      invitation.accept({}).should be_false
      invitation.should_not be_destroyed

      invitation.accept(Factory.attributes_for(:user)).should be_true
      invitation.should be_destroyed
    end
  end
end
