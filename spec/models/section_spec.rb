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
    it "should be scoped at project" do
      project = Factory(:project)
      
      section_0 = Factory(:section)
      section_1 = Factory(:section, :project_id => project.id)
      section_2 = Factory(:section, :project_id => project.id)
      section_3 = Factory(:section, :project_id => project.id)
      section_4 = Factory(:section, :project_id => project.id)
      
      section_0.position.should == 1
      section_1.position.should == 1
      section_2.position.should == 2
      section_3.position.should == 3
      section_4.position.should == 4
    end
  end
  
end
