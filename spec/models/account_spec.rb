require 'spec_helper'

describe Account do
    it_should_allow_mass_assignment_only_of :name

    it { should belong_to(:owner) }
    it { should validate_presence_of(:name) }
    it { Factory(:account).should validate_uniqueness_of(:name) }

    it { should have_many(:account_users) }
    it { should have_many(:users) }
    it { should have_many(:projects) }


    describe "#admin?" do
      before do
        @account_user = AccountUser.new
        @account_user.user    = @user    = Factory(:user)
        @account_user.account = @account = Factory(:account)
      end

      it "should be false if account_user.admin is false" do
        @account_user.update_attribute :admin, false

        @account.admin?(@user).should be_false
      end

      it "should be true if account_user.admin is true" do
        @account_user.update_attribute :admin, true

        @account.admin?(@user).should be_true
      end

      it "should be false if account_user doesn't exists at all" do
        @account.admin?(@user).should be_false
      end

      it "should be true if owner is same as user, independent of account_user" do
        @account.owner_id = @user.id
        @account.admin?(@user).should be_true
      end
    end

    describe "#set_admin_status" do
      it "should set AccountUser#admin? the given user" do
        account = Factory(:account)
        user = Factory(:user)

        Factory(:account_user, :user => user, :account => account)

        account.admin?(user).should be_false

        account.set_admin_status(user, true)
        account.admin?(user).should be_true

        account.set_admin_status(user, false)
        account.admin?(user).should be_false
      end

      it "should do noting if user is not connected to the account" do
        account = Factory(:account)
        user = Factory(:user)

        account.set_admin_status(user, true)
        account.admin?(user).should be_false
      end
    end
end
