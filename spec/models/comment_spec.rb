require 'spec_helper'

describe Comment do
  it_should_allow_mass_assignment_only_of :text
  
  it { should validate_presence_of(:text) }
  it { should belong_to(:user) }
  it { should belong_to(:task) }
  
  it_should_have_counter_cache_of :task
  it_should_have_counter_cache_of :user
  
  describe "editable_by" do
    before do
      @comment = Factory(:comment)
    end
    
    it "should be false for user who is not comment creator" do
      @comment.editable_by(Factory(:user)).should be_false
    end
    
    it "should be true for the current user (if updated_at in Comment.EDITABLE_BY time)" do
      @comment.updated_at = Time.now
      @comment.editable_by(@comment.user).should be_true
    end
    
    it "should be false for the current user (if updated_at out of Comment.EDITABLE_BY time)" do
      @comment.updated_at = Time.now - 2 * Comment::EDITABLE_BY
      @comment.editable_by(@comment.user).should be_false
    end
  end
end
