require 'spec_helper'

describe Section do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:project) }
  it { should belong_to(:project) }
  
  it { should_not allow_mass_assignment_of(:project) }
  it { should_not allow_mass_assignment_of(:project_id) }
  it { should_not allow_mass_assignment_of(:position) }
  it { should allow_mass_assignment_of(:name) }

  describe "acts_as_list" do
    before do
      @project = Factory(:project)
    end
    
    def create_next_section
      Factory(:section, :project_id => @project.id)
    end
    
    def should_have_order_of(*sections)
      sections = sections.each(&:reload)
      sections.should == sections.sort_by(&:position)
    end
    
    it "should be scoped at project" do
      section_0 = Factory(:section)
      
      should_have_order_of(create_next_section, create_next_section, create_next_section)
      
      section_0.position.should == 1
    end
    
    describe "move_before" do
      before do
        @section   = create_next_section
        @section_1 = create_next_section
        @section_2 = create_next_section
        @section_3 = create_next_section
        
        should_have_order_of(@section, @section_1, @section_2, @section_3)
      end
      
      it "should move before section 1" do        
        @section.move_before(@section_1.id)
        
        should_have_order_of(@section, @section_1, @section_2, @section_3)
      end
      
      it "should move before section 2 " do        
        @section.move_before(@section_2.id)
        
        should_have_order_of(@section_1, @section, @section_2, @section_3)
      end
      
      it "should move before section 3" do        
        @section.move_before(@section_3.id)
        
        should_have_order_of(@section_1, @section_2, @section, @section_3)
      end
    end
  end
  
end
