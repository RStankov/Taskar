require 'spec_helper'

describe Event do
  it_should_allow_mass_assignment_only_of :user, :subject

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

  describe ".unseen_from" do
    it "should expect project_user and take :project_id, :user_id and :last_seen_event_at if exists or :created_at" do
      project_user = mock_model(ProjectUser)
      project_user.should_receive(:project_id).and_return 1
      project_user.should_receive(:user_id).and_return 1
      project_user.should_receive(:last_seen_event_at).and_return Time.now
      project_user.should_not_receive(:created_at)

      Event.unseen_from(project_user)
    end

    it "should expect project_user and take :project_id, :user_id and :created_at if :last_seen_event_at don't exists" do
      project_user = mock_model(ProjectUser)
      project_user.should_receive(:project_id).and_return 1
      project_user.should_receive(:user_id).and_return 1
      project_user.should_receive(:last_seen_event_at).and_return nil
      project_user.should_receive(:created_at)

      Event.unseen_from(project_user)
    end

    def mark_events_after(time, *events)
      Event.update_all ["updated_at = ?", time], ["id IN (?)", events.collect(&:id)]
    end

    it "should show all unseen events for this user" do
      last_seen = Time.now
      project = Factory(:project)

      # should not be unseen events
      Factory(:event, :project => project)                              # event in same project, but before user date

      project_user = Factory(:project_user, :project => project)
      project_user.should_not be_new_record

      other_user = Factory(:project_user)
      other_user.should_not be_new_record

      # should not be unseen events
      unneeded_event_1 = Factory(:event)                                                   # unrelated event
      unneeded_event_2 = Factory(:event, :user => project_user.user)                       # event by the same user
      unneeded_event_3 = Factory(:event, :user => project_user.user, :project => project)  # event by the same user in the same project

      # should see those events
      unseen_event_1 = Factory(:event, :project => project)
      unseen_event_2 = Factory(:event, :project => project)

      mark_events_after last_seen + 5.minutes, unneeded_event_1, unneeded_event_2, unneeded_event_3
      mark_events_after last_seen + 5.minutes, unseen_event_1, unseen_event_2

      Event.unseen_from(other_user).should == []
      Event.unseen_from(project_user).should == [unseen_event_1, unseen_event_2].map(&:reload)

      # mark events as seen
      last_seen += 6.minutes

      project_user.update_attribute :last_seen_event_at, last_seen
      other_user.update_attribute   :last_seen_event_at, last_seen

      # should not be unseen events
      unneeded_event_4 = Factory(:event)                                                   # unrelated event
      unneeded_event_5 = Factory(:event, :user => project_user.user)                       # event by the same user
      unneeded_event_6 = Factory(:event, :user => project_user.user, :project => project)  # event by the same user in the same project

      # should see those events
      unseen_event_3 = Factory(:event, :project => project)
      unseen_event_4 = Factory(:event, :project => project)

      mark_events_after last_seen + 5.minutes, unneeded_event_4, unneeded_event_5, unneeded_event_6
      mark_events_after last_seen + 5.minutes, unseen_event_3, unseen_event_4

      Event.unseen_from(other_user).should == []
      Event.unseen_from(project_user).should == [unseen_event_3, unseen_event_4].map(&:reload)
    end
  end

  describe "#action" do
    def event_action_for(subject)
      Factory(:event, :subject => subject).action
    end

    it "should be 'commented' if subject is Comment" do
      event_action_for(Factory(:comment)).should == "commented"
    end

    it "should be 'deleted' if subject is destroyed?" do
      comment = Factory(:comment)
      comment.destroy

      event_action_for(comment).should == "deleted"
    end

    it "should be 'archived' if subject is archived? Task" do
      task = Factory(:task, :state => "completed")
      task.stub!(:archived?).and_return(true)

      event_action_for(task).should == "archived"
    end

    %w(opened completed rejected).each do |state|
      it "should be #{state} if subject is #{state} Task" do
        task = Factory(:task)
        task.stub!(:state).and_return(state)

        event_action_for(task).should == state
      end
    end

    it "should be 'shared' if subject is Status" do
      event_action_for(Factory(:status)).should == "shared"
    end
  end

  describe "#info" do
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

    it "should be subject.text if subject is Status" do
      status = Factory(:status, :text => "status text")
      event  = Factory(:event, :subject => status)

      event.info.should == "status text"
    end
  end

  describe "#activity" do
    def find_all_by_subject(subject)
       Event.find_all_by_subject_id_and_subject_type(subject.id, subject.class.name)
    end

    it "should create event if event doesn't exists for this subject" do
      task = Factory(:task)

      find_all_by_subject(task).should == []

      event = Event.activity(Factory(:user), task)

      event.new_record?.should be_false
      event.info.should == task.text

      find_all_by_subject(task).should == [event]
    end

    it "should update the event for this subject if one exists" do
      task = Factory(:task)
      event_1 = Event.activity(Factory(:user), task)

      find_all_by_subject(task).should == [event_1]

      event_2 = Event.activity(Factory(:user), task)

      event_1.user.should_not == event_2.user
      event_1.reload.user.should == event_2.user

      event_2.should == event_1
      find_all_by_subject(task).should == [event_1]
    end
  end

  describe "#linkable?" do
    before do
      @event = Event.new
    end

    it "should return false if subject is Status" do
      @event.subject = Status.new
      @event.should_not be_linkable
    end

    it "should return false if action is deleted" do
      @event.action = "deleted"
      @event.should_not be_linkable
    end

    %w(commented opened completed rejected archived).each do |action|
      it "should return true if action is #{action}" do
        @event.action = action
        @event.should be_linkable
      end
    end
  end

  describe "#url_options" do
    before do
      event = Event.new
      event.subject_type = 'Task'
      event.subject_id   =  1

      @options = event.url_options
    end

    it "should return hash with controller = subject_type.downcase.pluralize" do
      @options[:controller].should == 'tasks'
    end

    it "should return hash with action = :show " do
      @options[:action].should == :show
    end

    it "should return hash with id = subject_id " do
      @options[:id].should == 1
    end
  end

  describe "#type" do
    before do
      @event = Event.new { |event| event.subject_type = "Task" }
    end

    it "should return subject_type lowercased" do
      @event.type.should == "task"
    end

    it "should be cached" do
      @event.type.should == "task"

      @event.subject_type = "Comment"

      @event.type.should == "task"
    end
  end

end