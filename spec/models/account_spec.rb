require 'spec_helper'

describe Account do
  it_should_allow_mass_assignment_only_of :name

  it { should belong_to(:owner) }
  it { should validate_presence_of(:name) }
  it { Factory(:account).should validate_uniqueness_of(:name) }

  it { should have_many(:account_users) }
  it { should have_many(:users) }
  it { should have_many(:projects) }
  it { should have_many(:invitations) }

  let(:account) { Factory(:account) }
  let(:user) { Factory(:user) }

  it "can tell if an user is his owner" do
    account = create :account
    account.owner?(account.owner).should be_true
    account.owner?(create(:user)).should be_false
  end

  describe "#admin?" do
    let(:account_user) do
      AccountUser.new.tap do |account_user|
        account_user.user    = user
        account_user.account = account
      end
    end

    it "returns false if account_user.admin is false" do
      account_user.update_attribute :admin, false

      account.admin?(user).should be_false
    end

    it "returns true if account_user.admin is true" do
      account_user.update_attribute :admin, true

      account.admin?(user).should be_true
    end

    it "returns false if account_user doesn't exists at all" do
      account.admin?(user).should be_false
    end

    it "returns true if owner is same as user, independent of account_user" do
      account.owner_id = user.id
      account.admin?(user).should be_true
    end
  end
end
