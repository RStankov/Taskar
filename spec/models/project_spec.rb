require 'spec_helper'

describe Project do
  it_should_allow_mass_assignment_only_of :name, :user_ids
  
  it { should validate_presence_of(:name) }
  it { should have_many(:sections) }
  it { should have_many(:participants) }
  it { should have_many(:users) }
  it { should have_many(:tasks) }
  it { should have_many(:comments) }
  
  describe "involves?" do
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
end
