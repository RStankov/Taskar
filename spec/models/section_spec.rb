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
    
    it "should be scoped at project" do
      section_0 = Factory(:section)
      section_1 = Factory(:section, :project_id => @project.id)
      section_2 = Factory(:section, :project_id => @project.id)
      section_3 = Factory(:section, :project_id => @project.id)
      section_4 = Factory(:section, :project_id => @project.id)
      
      section_0.position.should == 1
      section_1.position.should == 1
      section_2.position.should == 2
      section_3.position.should == 3
      section_4.position.should == 4
    end
    
    describe "move_at" do
      before do
        @section = Factory(:section, :project_id => @project.id)
      end
      
      it "should make position to 1 on move to 'top'" do
        @section.move_after "first"
        
        @section.valid?.should be_true
        @section.position.should == 1
      end
      
      it "should make position to 3 (last) on move to 'bottom' (re-arranging sections)" do
        section_1 = Factory(:section, :project_id => @project.id)
        section_2 = Factory(:section, :project_id => @project.id)
        section_3 = Factory(:section, :project_id => @project.id)
        
        @section.position.should  == 1
        section_1.position.should == 2
        section_2.position.should == 3
        section_3.position.should == 4
        
        @section.move_after "last"
        
        section_1.reload.position.should == 1
        section_2.reload.position.should == 2
        section_3.reload.position.should == 3
        @section.position.should         == 4
      end
      
      it "should move after given section" do
        section_1 = Factory(:section, :project_id => @project.id)
        section_2 = Factory(:section, :project_id => @project.id)
        
        @section.position.should  == 1
        section_1.position.should == 2
        section_2.position.should == 3
        
        @section.move_after section_1
        
        section_1.reload.position.should == 1
        @section.position.should         == 2
        section_2.reload.position.should == 3
      end
    end
  end
  
end
