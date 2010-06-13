require 'spec_helper'

describe User do
  describe "validation" do
    it { should_not allow_mass_assignment_of(:encrypted_password) }
    it { should_not allow_mass_assignment_of(:salt) }
    it { should_not allow_mass_assignment_of(:token) }
    it { should_not allow_mass_assignment_of(:token_expires_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
    it { should_not allow_mass_assignment_of(:group_id) }
    it { should     allow_mass_assignment_of(:email) }
    it { should     allow_mass_assignment_of(:first_name) }
    it { should     allow_mass_assignment_of(:last_name) }
    it { should     allow_mass_assignment_of(:password) }
    it { should     allow_mass_assignment_of(:password_confirmation) }
    it { should     allow_mass_assignment_of(:avatar) }

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
end
