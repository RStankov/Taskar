require 'spec_helper'

describe Task do
  it_should_allow_mass_assignment_only_of :text, :insert_before
  
  it { should_not allow_mass_assignment_of(:status) }
  it { should_not allow_mass_assignment_of(:position) }
  it { should_not allow_mass_assignment_of(:section_id) }
  
  it { should belong_to(:section) }
  it { should have_many(:comments)}
  
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:section) }
  
  describe "acts_as_list" do
    before do
      @section = Factory(:section)
    end
    
    def create_next_task(section = @section)
      Factory(:task, :section_id => section.id)
    end
    
    def should_have_order_of(*tasks)
      tasks = tasks.map(&:reload)
      tasks.collect(&:id).should == tasks.sort_by(&:position).collect(&:id)
    end
    
    it "should be scoped at section" do
      task_0 = Factory(:task)
      
      should_have_order_of(create_next_task, create_next_task, create_next_task)
      
      task_0.position.should == 1
    end
    
    describe "insert_before property" do
      before do
        @task_1 = create_next_task
        @task_2 = create_next_task
        @task_3 = create_next_task
      end
      
      it "should be inserted before 1" do
        @task = Factory(:task, :section_id => @section.id, :insert_before => @task_1.id)
        
        should_have_order_of(@task, @task_1, @task_2, @task_3)
      end
      
      
      it "should be inserted before 2" do
        @task = Factory(:task, :section_id => @section.id, :insert_before => @task_2.id)
        
        should_have_order_of(@task_1, @task, @task_2, @task_3)
      end
      
      
      it "should be inserted before 3" do
        @task = Factory(:task, :section_id => @section.id, :insert_before => @task_3.id)
        
        should_have_order_of(@task_1, @task_2, @task, @task_3)
      end

      it "should be inserted last" do
        @task = Factory(:task, :section_id => @section.id, :insert_before => nil)

        should_have_order_of(@task_1, @task_2, @task_3, @task)
      end
      
    end
  
    describe "reorder" do
      before do
        @task_1 = create_next_task
        @task_2 = create_next_task
        @task_3 = create_next_task
        @task_4 = create_next_task
      end
      
      it "should accept nil as argument" do
        lambda { Task.reorder( nil ) }.should_not raise_error
      end
      
      it "should take array of task ids and sort them" do
        Task.reorder([@task_2.id, @task_4.id, @task_1.id, @task_3.id])
        
        should_have_order_of @task_2, @task_4, @task_1, @task_3
      end
      
      it "should ensure that given tasks don't change their parent_ids" do
        s2  = Factory(:section)
        t21 = create_next_task(s2)
        t22 = create_next_task(s2)
        
        Task.reorder([@task_3.id, t21.id, @task_1.id, t22.id, @task_4.id, @task_2.id])
        
        should_have_order_of @task_3, @task_1, @task_4, @task_2
        
        [@task_3, @task_1, @task_4, @task_2].each do |task|
          task.reload.section_id.should == @section.id
        end
        
        [t21, t22].each do |task|
          task.reload.section_id.should == s2.id
        end
      end
    end
  end

  describe "status validation" do
    [-1, 0, 1].each do |value|
      it "should be valid when is #{value}" do
        task = Task.new
        task.status = value
        task.valid?
        
        task.errors.on(:status).should be_nil
      end
    end
    
    [-3, -2, 2, 3].each do |value|
      it "should not be valid when is #{value}" do
        task = Task.new
        task.status = value
        task.valid?
        
        task.errors.on(:status).should_not be_nil
      end
    end
  end

  describe "state" do
    def task_with_status(status)
      Task.new do |task|
        task.status = status
      end
    end
        
    def task_with_state(state)
      Task.new do |task|
        task.state = state
      end
    end
    
    it "should be 'opened' if status is 0" do
      task_with_status(0).state.should == "opened"
    end

    it "should be 'completed' if status is 1" do
      task_with_status(1).state.should == "completed"
    end
        
    it "should be 'rejected' if status is -1" do
      task_with_status(-1).state.should == "rejected"
    end
    
    it "should set status to 0 when set as 'opened'" do
      task_with_state('opened').status.should == 0
    end

    it "should set status to 1 when set as 'completed'" do
      task_with_state('completed').status.should == 1
    end

    it "should set status to -1 when set as 'rejected'" do
      task_with_state('rejected').status.should == -1
    end
  end
  
  describe "search" do
    it "should find :all with :conditions => text like '%ss%'" do
      ss = "search term"
      
      Task.should_receive(:find).with(:all, :conditions => ["text LIKE :ss", {:ss => "%#{ss.gsub(' ', '%')}%"}], :limit => 20)
      Task.search(ss)
    end
    
    it "should have limit as second argument" do
      ss = "search term"

      Task.should_receive(:find).with(:all, :conditions => ["text LIKE :ss", {:ss => "%#{ss.gsub(' ', '%')}%"}], :limit => 100)
      Task.search(ss, 100)
    end
    
    it "should find all containing the given text" do
      text = 'very specific text content'
      task = Factory(:task, :text => text.gsub(" ", "_") + " wrapped")
      
      Task.search(text).include?(task).should be_true
    end
  end
  
end
