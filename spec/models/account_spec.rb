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

  describe "#set_admin_status" do
    it "sets AccountUser#admin? the given user" do
      Factory(:account_user, :user => user, :account => account)

      account.admin?(user).should be_false

      account.set_admin_status(user, true)
      account.admin?(user).should be_true

      account.set_admin_status(user, false)
      account.admin?(user).should be_false
    end

    it "does noting if user is not connected to the account" do
      account.set_admin_status(user, true)
      account.admin?(user).should be_false
    end
  end

  describe "#set_user_projects" do
    def user_should_be_involved_in(projects)
      projects = [projects] unless projects.is_a? Array
      projects.map(&:reload).each do |project|
        project.involves?(user).should be_true
        ProjectUser.where(:user_id => user.id, :project_id => project.id).count.should == 1
      end
    end

    def user_should_not_be_involved_in(projects)
      projects = [projects] unless projects.is_a? Array
      projects.map(&:reload).each do |project|
        project.involves?(user).should be_false
        ProjectUser.where(:user_id => user.id, :project_id => project.id).count.should == 0
      end
    end

    it "handles nil and no array values" do
      account.set_user_projects(user, nil)
      account.set_user_projects(user, "string")
      account.set_user_projects(user, {:hash => "value"})
    end

    it "sets project_users connecting the user and the projects" do
      projects = (0..2).map { Factory(:project, :account_id => account.id) }

      account.set_user_projects(user, projects.map(&:id).map(&:to_s))

      user_should_be_involved_in projects
    end

    it "accepts only project_ids from the account" do
      account_projects = (0..2).map { Factory(:project, :account_id => account.id) }
      other_projects   = (0..2).map { Factory(:project) }

      account.set_user_projects(user, (account_projects + other_projects).map(&:id).map(&:to_s))

      user_should_be_involved_in account_projects
      user_should_not_be_involved_in other_projects
    end

    it "leaves any existing project_users connecting the user and the projects" do
      projects = (0..2).map { Factory(:project, :account_id => account.id) }

      project_user = Factory(:project_user, :project_id => projects[0].id, :user_id => user.id)

      user_should_be_involved_in projects[0]

      account.set_user_projects(user, projects.map(&:id).map(&:to_s))

      user_should_be_involved_in projects

      ProjectUser.where(:id => project_user.id).first.should_not be_nil
    end

    it "destroys any existing project_users connecting the user and other not completed projects from this account" do
      previous_projects = (0..2).map { Factory(:project, :account_id => account.id) }.each do |project|
        Factory(:project_user, :project_id => project.id, :user_id => user.id)
      end

      user_should_be_involved_in previous_projects

      new_projects = (0..2).map { Factory(:project, :account_id => account.id) }

      account.set_user_projects(user, new_projects.map(&:id).map(&:to_s))

      user_should_not_be_involved_in previous_projects
      user_should_be_involved_in new_projects
    end

    it "does not touch project_users outside the account" do
      outside_projects = (0..2).map { Factory(:project) }.each do |project|
        Factory(:project_user, :project_id => project.id, :user_id => user.id)
      end

      user_should_be_involved_in outside_projects

      projects = (0..2).map { Factory(:project, :account_id => account.id) }

      account.set_user_projects(user, projects.map(&:id).map(&:to_s))

      user_should_be_involved_in projects
      user_should_be_involved_in outside_projects
    end

    it "does not touch project_users on completed projects" do
      completed_projects = (0..2).map { Factory(:project, :account_id => account.id, :completed => true) }.each do |project|
        Factory(:project_user, :project_id => project.id, :user_id => user.id)
      end

      user_should_be_involved_in completed_projects

      projects = (0..2).map { Factory(:project, :account_id => account.id) }

      account.set_user_projects(user, projects.map(&:id).map(&:to_s))

      user_should_be_involved_in projects
      user_should_be_involved_in completed_projects
    end
  end

  describe "#remove_user" do
    it "destroys user's account user (only of this account)" do
      AccountUser.create :account_id => account.id, :user_id => user.id

      2.times { Factory(:account_user, :account_id => account.id )}
      2.times { Factory(:account_user, :user_id => user.id ) }

      user.reload.should have(3).account_users
      account.reload.should have(3).account_users

      account.reload.users.should include(user)

      account.remove_user(user).should be_true

      user.reload.should have(2).account_users
      account.reload.should have(2).account_users

      account.reload.users.should_not include(user)
    end

    it "destroys user's project_users (only of this account)" do
      project_1 = Factory(:project, :account_id => account.id)
      project_2 = Factory(:project, :account_id => account.id)

      ProjectUser.create :project_id => project_1.id, :user_id => user
      ProjectUser.create :project_id => project_2.id, :user_id => user

      2.times { Factory(:project_user, :project_id => project_1.id )}
      2.times { Factory(:project_user, :project_id => project_2.id )}
      2.times { Factory(:project_user, :user_id => user.id ) }

      user.reload.should have(4).projects
      project_1.reload.should have(3).users
      project_2.reload.should have(3).users

      user.projects.should include(project_1)
      user.projects.should include(project_2)

      project_1.reload.users.should include(user)
      project_2.reload.users.should include(user)

      account.remove_user(user).should be_true

      user.reload.should have(2).projects
      project_1.reload.should have(2).users
      project_2.reload.should have(2).users

      user.projects.should_not include(project_1)
      user.projects.should_not include(project_2)

      project_1.reload.users.should_not include(user)
      project_2.reload.users.should_not include(user)
    end

    it "can't destroy admin users" do
      AccountUser.create :account_id => account.id, :user_id => user.id

      account.stub(:admin?).with(user).and_return true
      account.reload.users.should include(user)

      account.remove_user(user).should be_false
      account.reload.users.should include(user)
    end
  end
end
