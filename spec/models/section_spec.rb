require 'spec_helper'

describe Section do
  it_should_allow_mass_assignment_only_of :name, :text, :insert_before
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:project) }
  it { should belong_to(:project) }
  it { should have_many(:tasks) }

  describe "acts_as_list" do
    before do
      @project = Factory(:project)
    end
    
    def create_next_section(project = @project)
      Factory(:section, :project_id => project.id)
    end
    
    def should_have_order_of(*sections)
      sections = sections.map(&:reload)
      sections.collect(&:id).should == sections.sort_by(&:position).collect(&:id)
    end
    
    it "should be scoped at project" do
      section_0 = Factory(:section)
      
      should_have_order_of(create_next_section, create_next_section, create_next_section)
      
      section_0.position.should == 1
    end
    
    describe "insert_before property" do
      before do
        @section_1 = create_next_section
        @section_2 = create_next_section
        @section_3 = create_next_section
        @section_4 = create_next_section
      end
      
      def create_section_before(before)
        @section = Factory(:section, :project_id => @project.id, :insert_before => before ? before.id : nil)
      end
        
      
      it "should be inserted before 1" do
        create_section_before(@section_1)
        should_have_order_of(@section, @section_1, @section_2, @section_3, @section_4)
      end
      
      
      it "should be inserted before 2" do
        create_section_before(@section_2)
        should_have_order_of(@section_1, @section, @section_2, @section_3, @section_4)
      end
      
      
      it "should be inserted before 3" do
        create_section_before(@section_3)
        
        should_have_order_of(@section_1, @section_2, @section, @section_3, @section_4)
      end

      it "should be inserted last" do
        create_section_before(nil)

        should_have_order_of(@section_1, @section_2, @section_3, @section_4, @section)
      end
      
    end
  
    describe "reorder" do
      before do
        @section_1 = create_next_section
        @section_2 = create_next_section
        @section_3 = create_next_section
        @section_4 = create_next_section
      end

      it "should accept nil as argument" do
        lambda { Section.reorder( nil ) }.should_not raise_error
      end

      it "should take array of section ids and sort them" do
        Section.reorder([@section_2.id, @section_4.id, @section_1.id, @section_3.id])

        should_have_order_of @section_2, @section_4, @section_1, @section_3
      end

      it "should ensure that given sections don't change their parent_ids" do
        p2  = Factory(:project)
        s21 = create_next_section(p2)
        s22 = create_next_section(p2)

        Section.reorder([@section_3.id, s21.id, @section_1.id, s22.id, @section_4.id, @section_2.id])

        should_have_order_of @section_3, @section_1, @section_4, @section_2

        [@section_3, @section_1, @section_4, @section_2].each do |section|
          section.reload.project_id.should == @project.id
        end

        [s21, s22].each do |section|
          section.reload.project_id.should == p2.id
        end
      end
    end
  end
  
  describe "archived=" do
    it "should call move_to_bottom" do
      section = Factory(:section)
      section.should_receive(:move_to_bottom)
      section.archived = true
      section.archived?.should be_true
    end
    
    it "should convert the given parameter to boolean" do
      section = Section.new
      section.archived = "true"
      section.archived?.should be_true
      section.archived = nil
      section.archived?.should be_false
    end
    
    it "should not be able to proccedd if the is atleas one unarchived task" do
      section = Factory(:section)
      
      Factory(:task, :section => section)
      
      section.archived = true
      section.archived?.should be_false
    end
  end

  describe "current_tasks" do
    before do
      @section = Factory(:section)
      
      @unarchived_task  = Factory(:task, :section => @section, :status => 1)
      @archived_task    = Factory(:task, :section => @section, :status => 1, :archived => true)
    end
    
    it "should return archived tasks if section is archived" do
      @section.stub!(:archived?).and_return true
      @section.current_tasks.should == [@archived_task]
    end
    
    it "should return unachived tasks if section is not actived" do
      @section.stub!(:archived?).and_return false
      @section.current_tasks.should == [@unarchived_task]
    end
  end
end
