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
    before do
      @project = Factory(:project)
      @user    = Factory(:user)
    end

    it "should return true if user is involved in the project" do
      @project.users << @user
      @project.involves?(@user).should be_true
    end

    it "should return false if user is not involved in the project" do
      @project.involves?(@user).should be_false
    end
  end

  describe "#user_ids" do
    it "should allow users from project account to be project participents" do
      account = Factory(:account)
      user_ids = (1..3).map { Factory(:user) }.map &:id

      user_ids.each do |user_id|
        AccountUser.create :account => account, :user_id => user_id
      end

      project = Factory(:project, :account => account, :user_ids => user_ids)
      project.should_not be_new_record
      project.users.count.should == 3
    end

    it "should not allow users from other accounts to be added to project participents" do
      user_ids = (1..3).map { Factory(:user) }.map &:id

      project = Factory(:project, :user_ids => user_ids)
      project.should_not be_new_record
      project.users.count.should == 0
    end

    it "should allow only user from project account and reject the others" do
      account = Factory(:account)
      account_user_ids = (1..2).map { Factory(:user) }.map &:id

      account_user_ids.each do |user_id|
        AccountUser.create :account => account, :user_id => user_id
      end

      user_ids = (1..4).map { Factory(:user) }.map &:id

      project = Factory(:project, :account => account, :user_ids => (user_ids + account_user_ids).shuffle)
      project.should_not be_new_record
      project.users.count.should == 2
    end
  end
end
