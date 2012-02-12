require 'spec_helper'

describe AccountMember do
  let(:account_user)  { create :account_user }
  let(:user)          { account_user.user }
  let(:account)       { account_user.account }
  let(:member)        { AccountMember.new(user, account) }

  it "delegates to user" do
    user = double :full_name => 'Radoslav Stankov', :email => 'rs@example.com', :avatar => 'avatar'
    member = AccountMember.new(user, double)

    member.full_name.should eq user.full_name
    member.email.should eq user.email
    member.avatar.should eq user.avatar
  end

  it "can tell if an user is account owner" do
    user    = double :id => 1
    account = double :owner_id => 1

    AccountMember.new(user, account).should be_owner
  end

  it "is equal to same user or account member" do
    AccountMember.new(user, account).should == user
    AccountMember.new(user, account).should == AccountMember.new(user, account)
  end

  it "can find all account members for an account" do
    AccountMember.for(account).should eq [AccountMember.new(user, account)]
  end

  describe "find" do
    it "finds an account member by account and user id" do
      member = AccountMember.find(account, user.id)
      member.user.should eq user
      member.account.should eq account
    end

    it "raises record not found if user doesn't exists in this account" do
      expect { AccountMember.find(create(:account), create(:user).id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "admin?" do
    let(:user)    { create :user }
    let(:account) { create :account }

    it "returns true if users is account owner" do
      user    = double :id => 1
      account = double :owner_id => 1

      AccountMember.new(user, account).should be_admin
    end

    it "returns true if account user connecting the user and the account is admin" do
      create :account_user, :account =>  account, :user => user, :admin => true

      AccountMember.new(user, account).should be_admin
    end

    it "returns false if account user connecting the user and the account is admin" do
      create :account_user, :account =>  account, :user => user, :admin => true

      AccountMember.new(user, account).should be_admin
    end
  end

  describe "(removable)" do
    let(:member) { AccountMember.new(double, double) }

    it "can be removed if is not an admin" do
      member.stub :admin? => false
      member.should be_removable
    end

    it "can not be removed if is admin" do
      member.stub :admin? => true
      member.should_not be_removable
    end
  end

  describe "remove" do
    it "destroys user's account user" do
      member.remove

      account.users.should_not include user
    end

    it "destroys user's project users" do
      project = create :project, :account => account

      create :project_user, :user => user, :project => project

      member.remove

      project.users.should_not include user
    end

    it "can't destroy admins" do
      member.stub :admin? => true

      member.remove

      account.users.should include user
    end

    it "doesn't touch any other accounts the user is involved in" do
      other_account = create(:account_user, :user => user).account

      member.remove

      other_account.users.should include user
    end

    it "doesn't touch any other projects the user is involved in" do
      other_project = create(:project_user, :user => user).project

      member.remove

      other_project.users.should include user
    end
  end

  describe "set admin status" do
    it "can give admin rights to a member" do
      member.set_admin_status_to true
      member.should be_admin
    end

    it "can remove admin rights from a member" do
      member.set_admin_status_to false
      member.should_not be_admin
    end
  end

  describe "set projects" do
    it "gives access to specified projects from member's account" do
      project = create :project, :account => account
      other_project = create :project

      member.set_projects [project.id, other_project.id]

      project.users.should include user
      other_project.users.should_not include user
    end

    it "removes access from not completed projects, who are not specified" do
      project = create :project, :account => account
      completed_project = create :project, :account => account, :completed => true

      create :project_user, :user => user, :project => project
      create :project_user, :user => user, :project => completed_project

      member.set_projects []

      project.users.should_not include user
      completed_project.users.should include user
    end

    it "leaves any existing project users records" do
      project = create :project, :account => account
      project_user = create :project_user, :user => user, :project => project

      member.set_projects [project.id]

      ProjectUser.find(project_user.id).should eq project_user
    end

    it "does not touch project users outside the account" do
      outside_project = create(:project_user, :user => user).project

      member.set_projects []

      outside_project.users.should include user
    end
  end
end
