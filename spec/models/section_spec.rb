require 'spec_helper'

describe Section do
  it_should_allow_mass_assignment_only_of :name, :insert_before
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:project) }
  it { should belong_to(:project) }
  it { should have_many(:tasks) }

  describe "acts_as_list" do
    before do
      @project = Factory(:project)
    end
    
    def create_next_section
      Factory(:section, :project_id => @project.id)
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
      end
      
      it "should be inserted before 1" do
        @section = Factory(:section, :project_id => @project.id, :insert_before => @section_1.id)
        
        should_have_order_of(@section, @section_1, @section_2, @section_3)
      end
      
      
      it "should be inserted before 2" do
        @section = Factory(:section, :project_id => @project.id, :insert_before => @section_2.id)
        
        should_have_order_of(@section_1, @section, @section_2, @section_3)
      end
      
      
      it "should be inserted before 3" do
        @section = Factory(:section, :project_id => @project.id, :insert_before => @section_3.id)
        
        should_have_order_of(@section_1, @section_2, @section, @section_3)
      end

      it "should be inserted last" do
        @section = Factory(:section, :project_id => @project.id, :insert_before => nil)

        should_have_order_of(@section_1, @section_2, @section_3, @section)
      end
      
    end
  end
  
end
