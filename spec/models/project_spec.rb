require 'spec_helper'

describe Project do
  it_should_allow_mass_assignment_only_of :name, :user_ids

  it { should validate_presence_of(:name) }
  it { Factory(:project).should validate_uniqueness_of(:name).scoped_to(:account_id) }

  it { should have_many(:sections) }
  it { should have_many(:participants) }
  it { should have_many(:users) }
  it { should have_many(:tasks) }
  it { should have_many(:comments) }
  it { should have_many(:events) }
  it { should have_many(:statuses) }
  it { should belong_to(:account) }

  describe "#involves?" do
    let(:project){ Factory(:project) }
    let(:user){ Factory(:user) }

    it "returns true if user is involved in the project" do
      project.users << user
      project.involves?(user).should be_true
    end

    it "returns false if user is not involved in the project" do
      project.involves?(user).should be_false
    end
  end

  describe "#user_ids" do
    it "allows users from project account to be project participents" do
      account = Factory(:account)
      user_ids = (1..3).map { Factory(:user) }.map &:id

      user_ids.each do |user_id|
        AccountUser.create :account => account, :user_id => user_id
      end

      project = Factory(:project, :account => account, :user_ids => user_ids)
      project.should_not be_new_record
      project.should have(3).users
    end

    it "don't allow users from other accounts to be added to project participents" do
      user_ids = (1..3).map { Factory(:user) }.map &:id

      project = Factory(:project, :user_ids => user_ids)
      project.should_not be_new_record
      project.should have(0).users
    end

    it "allows only user from project account and reject the others" do
      account = Factory(:account)
      account_user_ids = (1..2).map { Factory(:user) }.map &:id

      account_user_ids.each do |user_id|
        AccountUser.create :account => account, :user_id => user_id
      end

      user_ids = (1..4).map { Factory(:user) }.map &:id

      project = Factory(:project, :account => account, :user_ids => (user_ids + account_user_ids).shuffle)
      project.should_not be_new_record
      project.should have(2).users
    end
  end
end
