require 'spec_helper'

describe Event do
  it_should_allow_mass_assignment_only_of :user, :action, :subject
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:subject) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:subject_id) }
  it { should validate_presence_of(:subject_type) }
  
  it "should inherit the project_id from it's subject" do
    task  = Factory(:task)    
    event = Factory(:event, :subject => task)
    
    event.save.should be_true
    event.project_id.should  == task.project_id
  end
  
  describe "info" do
    it "should be subject.text if subject is Task" do
      task  = Factory(:task, :text => "task text")
      event = Factory(:event, :subject => task)
      
      event.info.should == "task text"
    end
    
    it "should be subject.task.text if subject is Comment" do
      task    = Factory(:task, :text => "comment task text")
      comment = Factory(:comment, :task => task)
      event   = Factory(:event, :subject => comment)
      
      event.info.should == "comment task text"
    end
  
  
    it "should be subject.name if subject is Section" do
      task  = Factory(:task, :text => "task test")
      event = Factory(:event, :subject => task)
      
      event.info.should == "task test"
    end
  end

  describe "activity" do
    def find_all_by_subject(subject)
       Event.find_all_by_subject_id_and_subject_type(subject.id, subject.class.name)
    end
    
    it "should create event if event doesn't exists for this subject" do
      task = Factory(:task)
      
      find_all_by_subject(task).should == []

      event = Event.activity(Factory(:user), :created, task)
      
      event.new_record?.should be_false
      event.info.should == task.text
      
      find_all_by_subject(task).should == [event]
    end
    
    it "should update the event for this subject if one exists" do
      task = Factory(:task)
      event_1 = Event.activity(Factory(:user), :created, task)
      
      find_all_by_subject(task).should == [event_1]
      
      event_2 = Event.activity(Factory(:user), :updated, task)
      
      event_2.should == event_1
      find_all_by_subject(task).should == [event_1]
    end
  end
end
