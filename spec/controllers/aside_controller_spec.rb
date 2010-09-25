require 'spec_helper'

describe AsideController do
  subject { controller }

  describe "with project user" do
    before { sign_with_project_user }

    describe "GET index" do
      before do
        Project.should_receive(:find).with("1").and_return(mock_project)
        @current_user.should_receive(:responsibilities_count).with(mock_project.id).and_return(321)

        controller.stub_chain(:project_user, :unseen_events, :count).and_return 4

        mock_project.should_receive(:participants).and_return @participants = [1,2,3]

        xhr :get, :index, :project_id => "1"
      end

      it { should assign_to(:responsibilities_count).with(321) }
      it { should assign_to(:unseen_events_count).with(4) }
      it { should assign_to(:participants).with(@participants) }
      it { should render_template("index") }
    end
  end

  describe "with user outside project" do
    before { sign_with_user_outside_the_project }

    {
      :index      => 'get(:index, :project_id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
         Project.should_receive(:find).with("1").and_return(mock_project)

        eval code
      end
    end
  end
end
