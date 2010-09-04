require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksStats do
  def mock_subject(stats = {})
    subject = Object.new
    TasksStats::STATS.each do |(type, color)|
      subject.stub_chain :tasks, type, :size => stats.delete(type) || 0
    end
    subject
  end
  
  describe "#needed?" do
    it "should be false if 0 tasks are associated" do
      subject = mock_subject
      
      TasksStats.new(subject).should_not be_needed
    end
    
    it "should be false if only one type of tasks are associated" do
      subject = mock_subject :completed => 10
      
      TasksStats.new(subject).should_not be_needed
    end
    it "should be true if there are 2 or more type of tasks" do
      subject = mock_subject :rejected => 11, :opened => 12
      
      TasksStats.new(subject).should be_needed
      
      subject = mock_subject :completed => 44, :opened => 42, :rejected => 4
      
      TasksStats.new(subject).should be_needed
    end
  end
  
  describe "#empty_text" do
    it "should be tasks_stats.empty.tasks if no tasks are presented" do
      stats = TasksStats.new(mock_subject)
      stats.should_not be_needed
      stats.empty_text.should == I18n.t("tasks_stats.empty.tasks")
    end
    
    TasksStats::STATS.each do |(type, color)|
      it "should be tasks_stats.empty.#{type} if only #{type} tasks are presented" do
        stats = TasksStats.new(mock_subject type => 1)
        stats.should_not be_needed
        stats.empty_text.should == I18n.t("tasks_stats.empty.#{type}", :count => 1)
        
        stats = TasksStats.new(mock_subject type => 10)
        stats.should_not be_needed
        stats.empty_text.should == I18n.t("tasks_stats.empty.#{type}", :count => 10)
      end
    end
  end
  
  describe "#text_for" do
    TasksStats::STATS.each do |(type, color)|
      it "should be tasks_stats.text.#{type} for :#{type}"
    end
  end
  
  describe "#stats" do
    it "should iterate throw all avaliable stats"
    it "should not iterate throw 0 stats"
    it "should give text, number, color"
  end
end