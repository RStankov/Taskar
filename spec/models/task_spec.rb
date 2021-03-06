require 'spec_helper'

describe Task do
  it_should_allow_mass_assignment_only_of :text, :insert_after, :responsible_party_id

  it { should belong_to(:section) }
  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should belong_to(:responsible_party) }
  it { should have_many(:comments)}
  it { should have_one(:event) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:section) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }

  it "should inherit the project_id from it's parent section" do
    section = Factory(:section)
    task    = Factory(:task, :section_id => section.id)

    task.save.should be_true
    task.project_id.should  == section.project_id
  end

  it "should not be added to archived section" do
    section = Factory(:section, :archived => true)
    task    = Factory.build(:task, :section => section)

    task.save.should be_false
    task.errors[:base].should == [I18n.t('activerecord.errors.tasks.archived_section')]
  end

  describe "section_id changes" do
    it "should not allow to set section_id to section from other project" do
      task = Factory :task
      section = Factory :section, :project => Factory(:project)

      section.project_id.should_not == task.project_id

      task.section_id = section.id

      task.should_not be_valid
      task.should have(1).error_on(:section_id)
      task.save.should be_false
    end

    it "should allow to set section to section from the current project" do
      task = Factory :task
      section = Factory :section, :project => task.project

      section.project_id.should == task.project_id

      task.section_id = section.id

      task.should be_valid
      task.save.should be_true
    end
  end

  context "acts_as_list" do
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

    describe "insert_after property" do
      before do
        @task_1 = create_next_task
        @task_2 = create_next_task
        @task_3 = create_next_task
        @task_4 = create_next_task
      end

      it "should be inserted after 1" do
        @task = Factory(:task, :section_id => @section.id, :insert_after => @task_1.id)

        should_have_order_of(@task_1, @task, @task_2, @task_3, @task_4)
      end


      it "should be inserted after 2" do
        @task = Factory(:task, :section_id => @section.id, :insert_after => @task_2.id)

        should_have_order_of(@task_1, @task_2, @task, @task_3, @task_4)
      end


      it "should be inserted after 3" do
        @task = Factory(:task, :section_id => @section.id, :insert_after => @task_3.id)

        should_have_order_of(@task_1, @task_2, @task_3, @task, @task_4)
      end

      it "should be inserted last" do
        @task = Factory(:task, :section_id => @section.id, :insert_after => nil)

        should_have_order_of(@task_1, @task_2, @task_3, @task_4, @task)
      end

    end

    describe "#change_order_of" do
      before do
        @task_1 = create_next_task
        @task_2 = create_next_task
        @task_3 = create_next_task
        @task_4 = create_next_task
      end

      it "should accept nil as argument" do
        lambda { Task.change_order_of( nil ) }.should_not raise_error
      end

      it "should take array of task ids and sort them" do
        Task.change_order_of([@task_2.id, @task_4.id, @task_1.id, @task_3.id])

        should_have_order_of @task_2, @task_4, @task_1, @task_3
      end

      it "should ensure that given tasks don't change their parent_ids" do
        s2  = Factory(:section)
        t21 = create_next_task(s2)
        t22 = create_next_task(s2)

        Task.change_order_of([@task_3.id, t21.id, @task_1.id, t22.id, @task_4.id, @task_2.id])

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

        task.errors[:status].should be_empty
      end
    end

    [-3, -2, 2, 3].each do |value|
      it "should not be valid when is #{value}" do
        task = Task.new
        task.status = value
        task.valid?

        task.errors[:status].should_not be_empty
      end
    end
  end

  describe "#state" do
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

  describe "#search" do
    it "should have where conditions - text like '%ss%'" do
      ss = "search term"
      Task.search(ss).where_values.should == ["text LIKE '%search%term%'"]
    end

    it "should find all containing the given text" do
      text = 'very specific text content'
      task = Factory(:task, :text => text.gsub(" ", "_") + " wrapped")

      Task.search(text).include?(task).should be_true
    end
  end

  describe "#archived" do
    before do
      @task = Factory(:task)
    end

    describe "archived= method" do
      it "should not archive task if it state is opened" do
        @task.should_not_receive(:move_to_bottom)
        @task.state = "opened"
        @task.archived = true
        @task.archived?.should be_false
      end

      it "should unarchive task if it state is opened" do
        @task.should_receive(:move_to_bottom)
        @task.state = "opened"
        @task.archived = false
        @task.archived?.should be_false
      end

      it "should accept string 'true' and set it to true" do
        @task.should_receive(:move_to_bottom)
        @task.state = "completed"
        @task.archived = "true"
        @task.archived.should be_true
      end

      it "should accept string 'false' and set it to true" do
        @task.should_receive(:move_to_bottom)
        @task.state = "completed"
        @task.archived = "false"
        @task.archived.should be_false
      end

      %w(completed rejected).each do |state|
        [true, false].each do |archive|
          it "should set archive field to #{archive}, when state is #{state}" do
            @task.should_receive(:move_to_bottom)

            @task.state = state
            @task.archived = archive
            @task.archived?.should == archive
          end
        end
      end
    end

    describe "task state" do
      Task::STATES.each_value do |state|
        it "should not be changed to #{state} when task is archived" do
          @task.state = "completed"
          @task.archived = true

          @task.state = state

          @task.archived?.should be_true
          @task.state.should == "completed"
        end
      end
    end
  end

  describe "#editable?" do
    before do
      @task = Task.new
    end

    %w(completed rejected).each do |state|
      it "should not be true if state is #{state}" do
        @task.state = state
        @task.editable?.should be_false
      end
    end

    it "should be true if state is opened" do
      @task.state = "opened"
      @task.editable?.should be_true
    end
  end

  describe ".opened_in_project" do
    it "should return opened tasks in a project" do
      project = Factory(:project)
      section = Factory(:section, :project => project)

      Factory(:task)
      Factory(:task, :section => section, :status => 1)
      Factory(:task, :section => section, :status => -1)

      task = Factory(:task, :section => section, :status => 0)

      Task.opened_in_project(project).should == [task]
    end
  end

  describe "#toggle_archived" do
    it "should call update attribute with true if archived is false" do
      task = Factory.build(:task, :archived => false, :status => 1)
      task.should_not be_archived
      task.should_receive(:update_attribute).with(:archived, true)
      task.toggle_archived
    end

    it "should call update attribute with false if archived is true" do
      task = Factory.build(:task, :archived => true, :status => 1)
      task.should be_archived
      task.should_receive(:update_attribute).with(:archived, false)
      task.toggle_archived
    end
  end
end
