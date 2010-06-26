require 'spec_helper'

describe Comment do
  it_should_allow_mass_assignment_only_of :text
  
  it { should belong_to(:user) }
  it { should belong_to(:task) }
  it { should belong_to(:project) }
  
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:task) }
  it { should validate_presence_of(:project) }
  
  it_should_have_counter_cache_of :task
  it_should_have_counter_cache_of :user
  
  describe "editable_by?" do
    before do
      @comment = Factory(:comment)
    end
    
    it "should be false for user who is not comment creator" do
      @comment.editable_by?(Factory(:user)).should be_false
    end
    
    it "should be true for the current user (if updated_at in Comment::EDITABLE_BY time)" do
      @comment.updated_at = Time.now
      @comment.editable_by?(@comment.user).should be_true
    end
    
    it "should be false for the current user (if updated_at out of Comment::EDITABLE_BY time)" do
      @comment.updated_at = Time.now - 2 * Comment::EDITABLE_BY
      @comment.editable_by?(@comment.user).should be_false
    end
  end
  
  describe "editable_for" do 
    before do
      @comment = Factory(:comment)
    end
     
    it "should return diffrence between Comment::EDITABLE_BY and updated_at " do
      @comment.editable_for.should == (((@comment.updated_at + Comment::EDITABLE_BY) - Time.now) / 60).ceil
    end
    
    it "should return 0 if this is not editable" do
      @comment.updated_at = Time.now - 2 * Comment::EDITABLE_BY
      @comment.editable_for.should == 0
    end
  end
end
