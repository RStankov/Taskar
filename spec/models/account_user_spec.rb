require 'spec_helper'

describe AccountUser do
  it_should_allow_mass_assignment_only_of :user_id

  it { should belong_to(:user) }
  it { should belong_to(:account) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:account) }
  it { Factory(:account_user).should validate_uniqueness_of(:user_id).scoped_to(:account_id) }

  describe "#admin?" do
    it "should be just the normal admin column, if account owner is not the current user" do
      account_user = AccountUser.new
      account_user.admin = true
      account_user.should be_admin

      account_user = AccountUser.new
      account_user.admin = false
      account_user.should_not be_admin
    end

    it "should be true if accounts owner is the same user" do
      account_user = AccountUser.new
      account_user.user = Factory(:user)
      account_user.account = Factory(:account, :owner => account_user.user)
      account_user.admin = false

      account_user.should be_admin
    end
  end
end
