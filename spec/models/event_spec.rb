require 'spec_helper'

describe Event do
  it_should_allow_mass_assignment_only_of :action, :subject
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:subject) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:subject_id) }
  it { should validate_presence_of(:subject_type) }
  
  it "should inherit the project_id from it's subject" do
    section = Factory(:section)    
    event   = Factory(:event, :subject => section)
    
    event.save.should be_true
    event.project_id.should  == section.project_id
  end
  
end
