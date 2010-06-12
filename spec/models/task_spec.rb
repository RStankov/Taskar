require 'spec_helper'

describe Task do
  it { should allow_mass_assignment_of(:text) }
  it { should allow_mass_assignment_of(:insert_before) }
  it { should_not allow_mass_assignment_of(:status) }
  it { should_not allow_mass_assignment_of(:position) }
  it { should_not allow_mass_assignment_of(:section_id) }
  
  it { should belong_to(:section) }
  
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:section) }
  
  describe "acts_as_list" do
    before do
      @section = Factory(:section)
    end
    
    def create_next_task
      Factory(:task, :section_id => @section.id)
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
  end

  describe "state" do
    def task_with_status(status)
      Task.new do |task|
        task.status = status
      end
    end
    
    it "should be 'open' if status is 0" do
      task_with_status(0).state.should == "opened"
    end

    it "should be 'completed' if status is 1" do
      task_with_status(1).state.should == "completed"
    end
        
    it "should be 'rejected' if status is -1" do
      task_with_status(-1).state.should == "rejected"
    end
  end
end
