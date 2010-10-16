require 'spec_helper'

describe User do
  describe "relationships" do
    it { should have_many(:comments) }
    it { should have_many(:projects) }
    it { should have_many(:project_participations) }
    it { should have_many(:tasks) }
    it { should have_many(:responsibilities) }
    it { should have_many(:events) }
    it { should have_many(:statuses) }
    it { should have_many(:owned_accounts) }
    it { should have_many(:account_users) }
    it { should have_many(:accounts) }

    # deprecated
    it { should have_one(:owned_account) }
    it { should belong_to(:account) }
  end

  describe "validation" do
    it_should_allow_mass_assignment_only_of :email, :first_name, :last_name, :password, :password_confirmation, :avatar, :owned_account_attributes, :remember_me, :locale

    it { should validate_presence_of(:email) }
    it { Factory(:user).should validate_uniqueness_of(:email) }
    it { should_not allow_value('not valid address').for(:email) }
    it { should_not allow_value('domain.com').for(:email) }
    it { should_not allow_value('some@domain').for(:email) }
    it { should allow_value('some@domain.com').for(:email) }

    it { should allow_value("").for(:locale) }
    it { should allow_value("bg").for(:locale) }
    it { should allow_value("en").for(:locale) }

    it { should_not allow_value("ru").for(:locale) }
    it { should_not allow_value("ro").for(:locale) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should validate_presence_of(:password) }
    it { should ensure_length_of(:password).is_at_least(6).is_at_most(20) }

    it { User.should have_attached_file(:avatar) }

    it "should have password confirmation error" do
     user = Factory.build(:user, :password => '123456', :password_confirmation => 'blqkblqk')

     user.valid?.should be_false
     user.errors[:password].should_not be_empty
    end

    it "should not have password confirmation error" do
     user = Factory.build(:user, :password => '123456', :password_confirmation => '123456')

     user.valid?.should be_true
    end
  end

  describe "authentication" do
    before do
      @account  = Factory(:account)
      @user     = Factory(:user, :account => @account)
    end

    it "should find_for_authentication with correct" do
      User.find_for_authentication(:email => @user.email).should == @user
    end


    it "should find_for_authentication with account / correct email (no case sensative)" do
      User.find_for_authentication(:email => @user.email).should == @user
      User.find_for_authentication(:email => @user.email.upcase).should == @user
    end

    it "should not find_for_authentication with incorrect account / email" do
      User.find_for_authentication(:email => @user.email + 'test').should be_nil
    end

    it "should find_for_authentication with same password after update" do
      User.find_for_authentication(:email => @user.email).should == @user
      @user.update_attributes(:first_name => "new first name", :last_name => "new last name").should be_true
      User.find_for_authentication(:email => @user.email).should == @user
    end
  end

  it "should downcase the email address on save" do
    user = Factory.build(:user, :email => "BigCases@mail.com");
    user.save
    user.email.should == "bigcases@mail.com"
  end

  it "should have full_name witch is first_name + last_name" do
    user = Factory.build(:user, {:first_name => 'Radoslav', :last_name => 'Stankov'})
    user.full_name.should == "Radoslav Stankov"
  end

  it "should have short_name witch is first_name + first letter of the last_name" do
    user = Factory.build(:user, {:first_name => 'Radoslav', :last_name => 'Stankov'})
    user.short_name.should == "Radoslav S."
  end

  describe "#admin?" do
    it "should not be changable for account owner" do
      user               = Factory(:user, :admin => true)
      user.owned_account = Factory(:account)

      user.admin = false
      user.admin.should be_true
    end

    it "should be changable for non account owner" do
        user = Factory(:user, :admin => true)

        user.admin = false
        user.admin.should be_false

        user.admin = true
        user.admin.should be_true
    end
  end

  describe "#new_comment" do
    it "should build new comment from task, assign user.id to it" do
      task = Factory(:task)
      user = Factory(:user)
      comment = user.new_comment(task, {:text => "comment text"})

      comment.text.should  == "comment text"
      comment.user_id.should == user.id
      task.comments.detect {|c| c == comment}.should be_true
    end
  end

  describe "#new_task" do
    it "should build new coment from section, assign user.id to it" do
      section = Factory(:section)
      user    = Factory(:user)
      task    = user.new_task(section, {:text => "comment text"})

      task.text.should  == "comment text"
      task.user_id.should == user.id
      section.tasks.detect {|t| t == task}.should be_true
    end
  end

  describe "#new_status" do
    it "should build new statu from project, assign user.id to it" do
      project = Factory(:project)
      user    = Factory(:user)
      status  = user.new_status(project, {:text => "some status text"})

      status.text.should  == "some status text"
      status.user_id.should == user.id
      project.statuses.detect {|s| s == status}.should be_true
    end
  end

  describe "#responsibilities_count" do
    it "should get the count of all responsibilities who are with status = 0" do
      user = Factory(:user)

      section_1 = Factory(:section)

      (1..1).each { Factory(:task, :section => section_1, :responsible_party => user, :status => -1) }
      (1..2).each { Factory(:task, :section => section_1, :responsible_party => user, :status =>  1) }
      (1..3).each { Factory(:task, :section => section_1, :responsible_party => user, :status =>  0) }

      section_2 = Factory(:section)

      (1..4).each { Factory(:task, :section => section_2, :responsible_party => user, :status =>  0) }

      user.responsibilities_count(section_1.project_id).should == 3
      user.responsibilities_count(section_2.project_id).should == 4
    end
  end

  describe "owned_account" do
    before :each do
      @user                          = User.new Factory.attributes_for(:user)
      @user.owned_account_attributes = {:name => @account_name = Factory.build(:account).name }
      @user.save.should be_true
      @user.should_not be_new_record
    end

    it "should be created with name on user creation" do
      @user.owned_account.name.should == @account_name
    end

    it "should be same as user's account" do
      @user.owned_account.should == @user.account
    end

    it "should have user as owner" do
      @user.reload
      @user.owned_account.owner.should == @user
      @user.account.owner.should == @user
    end

    it "should make this user admin" do
      @user.admin?.should be_true
    end

    it "should be nil if account is assign to user" do
      account = Factory(:account)

      user                          = User.new Factory.attributes_for(:user)
      user.owned_account_attributes = {:name => Factory.build(:account).name}
      user.account                  = account

      user.save.should be_true
      user.reload
      user.owned_account.should be_nil
      user.account.should == account
      user.admin?.should be_false
    end
  end
end
