require 'spec_helper'

describe Comment do
  it_should_allow_mass_assignment_only_of :text
  
  it { should validate_presence_of(:text) }
  it { should belong_to(:user) }
  it { should belong_to(:task) }
  
  it "should have counter_cache on Task" do
    task = Factory(:task)
    
    task.comments_count.should == 0
    
    Factory(:comment, :task => task)
    Factory(:comment, :task => task)
    Factory(:comment, :task => task)
    
    task.reload.comments_count.should == 3
  end
end
