require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksStats do
  describe "#needed?" do
    it "should be false if 0 tasks are associated"
    it "should be false if only one type of tasks are associated"
    it "should be true if there are 2 or more type of tasks"
  end
  
  describe "#empty_text" do
    it "should be tasks_stats.empty.tasks if no tasks are presented"
    
    TasksStats::STATS.each do |(type, color)|
      it "should be tasks_stats.empty.#{type} if only #{type} tasks are presented"
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