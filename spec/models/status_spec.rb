require 'spec_helper'

describe Status do
  it_should_allow_mass_assignment_only_of :text

  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should have_one(:event) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:text) }

  it "sets project_user status to be this status on creation" do
    user          = Factory(:user)
    project       = Factory(:project)
    project_user  = Factory(:project_user, :user => user, :project => project)
    status        = Factory(:status, :text => "Status text", :user => user, :project => project)

    project_user.status.should be_nil
    project_user.reload.status.should == "Status text"
  end
end
