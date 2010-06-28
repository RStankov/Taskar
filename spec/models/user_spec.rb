require 'spec_helper'

describe User do
  describe "relationships" do
    it { should have_many(:comments) }
    it { should have_many(:projects) }
    it { should have_many(:project_participations) }
    it { should have_many(:tasks) }
    it { should have_many(:responsibilities) }
  end
  
  describe "validation" do
    it_should_allow_mass_assignment_only_of :email, :first_name, :last_name, :password, :password_confirmation, :avatar

    it { should validate_presence_of(:email) }
    it { Factory(:user).should validate_uniqueness_of(:email) }
    it { should_not allow_value('not valid address').for(:email) }
    it { should_not allow_value('domain.com').for(:email) }
    it { should_not allow_value('some@domain').for(:email) }
    it { should allow_value('some@domain.com').for(:email) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should validate_presence_of(:password) }
    it { should ensure_length_of(:password).is_at_least(6).is_at_most(20) }
    
    it { User.should have_attached_file(:avatar) }

    it "should have password confirmation error" do
     user = Factory.build(:user, :password => '123456', :password_confirmation => 'blqkblqk')

     user.valid?.should be_false
     user.errors.on(:password).should_not be_nil
    end

    it "should not have password confirmation error" do
     user = Factory.build(:user, :password => '123456', :password_confirmation => '123456')

     user.valid?.should be_true
    end
  end

  describe "authentication" do
    before do
      @user = Factory(:user)
    end

    it "should authenticate with correct password" do
      User.authenticate(:email => @user.email, :password => @user.password).should == @user
    end

    it "should authenticate with incorect password" do
      User.authenticate(:email => @user.email, :password => "foo_#{@user.password}").should be_nil
    end

    it "should authenticate with correct email (no case sensative) / password" do
      User.authenticate(:email => @user.email, :password => @user.password).should == @user
      User.authenticate(:email => @user.email.upcase, :password => @user.password).should == @user
    end

    it "should not authenticate with incorrect email / password" do
      User.authenticate(:email => @user.email, :password => @user.password + 'something').should be_nil
      User.authenticate(:email => @user.email + 'test', :password => @user.password).should be_nil
    end

    it "should authenticate with same password after update" do
      User.authenticate(:email => @user.email, :password => @user.password).should == @user
      @user.update_attributes(:first_name => "new first name", :last_name => "new last name").should be_true
      User.authenticate(:email => @user.email, :password => @user.password).should == @user
    end
  end

  it "should downcase the email address on save" do
    user = Factory.build(:user, :email => "BigCases@mail.com");
    user.save
    user.email.should == "bigcases@mail.com"
  end

  it "should have full_name witch is first_name + last_name" do 
    user = Factory(:user, {:first_name => 'Radoslav', :last_name => 'Stankov'})
    user.full_name.should == "Radoslav Stankov"
  end

  describe "new_comment" do
    it "should build new comment from task, assign user.id to it" do
      task = Factory(:task)
      user = Factory(:user)
      comment = user.new_comment(task, {:text => "comment text"})
      
      comment.text.should  == "comment text"
      comment.user_id.should == user.id
      task.comments.detect {|c| c == comment}.should be_true
    end
  end
  
  describe "new_task" do
    it "should build new coment from section, assign user.id to it" do
      section = Factory(:section)
      user    = Factory(:user)
      task    = user.new_task(section, {:text => "comment text"})
      
      task.text.should  == "comment text"
      task.user_id.should == user.id
      section.tasks.detect {|t| t == task}.should be_true
    end
  end

  describe "responsibilities_count" do
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
end
