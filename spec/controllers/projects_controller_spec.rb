require 'spec_helper'

describe ProjectsController do
  subject { controller }

  before do
    sign_in @current_user = Factory(:user)

    controller.stub(:current_user).and_return @current_user

    Account.stub(:find).with("1").and_return mock_account
  end

  describe "with admin user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return true
      mock_account.stub(:projects).and_return @projects = [mock_project]
    end

    describe "on collection action" do
      describe "GET index" do
        before do
          @projects.should_receive(:completed).and_return([@completed = mock(Project)])
          @projects.should_receive(:active).and_return([@active = mock(Project)])

          get :index, :account_id => "1"
        end

        it { should assign_to(:projects).with([@active]) }
        it { should assign_to(:completed).with([@completed]) }
        it { should render_template("index") }
      end

      describe "GET new" do
        before do
          @projects.should_receive(:build).and_return mock_project

          get :new, :account_id => "1"
        end

        it { should assign_to(:project).with(mock_project) }
        it { should render_template("new") }
      end

      describe "POST create" do
        before do
          @projects.should_receive(:build).with({'these' => 'params'}).and_return mock_project
        end

        describe "with valid params" do
          before do
            mock_project.stub(:save).and_return true

            post :create, :account_id => "1", :project => {:these => 'params'}
          end

          it { should assign_to(:project).with(mock_project) }
          it { should redirect_to(account_project_url(mock_account, mock_project)) }
        end

        describe "with invalid params" do
          before do
            mock_project.stub(:save).and_return false

            post :create, :account_id => "1", :project => {:these => 'params'}
          end

          it { should assign_to(:project).with(mock_project) }
          it { should render_template("new") }
        end
      end
    end

    describe "on member action" do
      before do
        @projects.should_receive(:find).with("2").and_return mock_project
      end

      describe "GET show" do
        before do
          mock_project.stub_chain :sections, :order => [mock_section]

          get :show, :account_id => "1", :id => "2"
        end

        it { should assign_to(:sections).with([mock_section]) }
        it { should assign_to(:project).with(mock_project) }
        it { should render_template("show") }
      end

      describe "GET edit" do
        before { get :edit, :account_id => "1", :id => "2" }

        it { should assign_to(:project).with(mock_project) }
        it { should render_template("edit") }
      end

      describe "PUT update" do
        describe "with valid params" do
          before do
            mock_project.should_receive(:update_attributes).with({'these' => 'params'}).and_return true
            put :update, :account_id => "1", :id => "2", :project => {:these => 'params'}
          end

          it { should assign_to(:project).with(mock_project) }
          it { should redirect_to(account_project_url(mock_account, mock_project)) }
        end

        describe "with invalid params" do
          before do
            mock_project.should_receive(:update_attributes).with({'these' => 'params'}).and_return false
            put :update, :account_id => "1", :id => "2", :project => {:these => 'params'}
          end

          it { should assign_to(:project).with(mock_project) }
          it { should render_template("edit") }
        end
      end

      describe "DELETE destroy" do
        before do
          mock_project.should_receive(:destroy)
          delete :destroy, :account_id => "1", :id => "2"
        end

        it { should redirect_to(account_projects_url(mock_account)) }
      end

      describe "PUT complete" do
        before do
          mock_project.stub(:completed=)
          mock_project.stub(:save)
        end

        it "should set completed flag to project to true" do
          mock_project.should_receive(:completed=).with(true)
          mock_project.should_receive(:save)

          put :complete, :account_id => "1", :id => "2", :complete => "foo"
        end

        it "should set completed flag to project to false" do
          mock_project.should_receive(:completed=).with(false)
          mock_project.should_receive(:save)

          put :complete, :account_id => "1", :id => "2"
        end

        it do
          put :complete, :account_id => "1", :id => "2", :complete => "foo"

          should redirect_to(account_project_url(mock_account, mock_project))
        end
      end
    end
  end

  describe "with normal user" do
    before do
      mock_account.should_receive(:admin?).with(@current_user).and_return false

      ensure_deny_access_is_called
    end

    {
      :index      => 'get(:index, :account_id => "1")',
      :show       => 'get(:show, :account_id => "1", :id => "2")',
      :new        => 'get(:new, :account_id => "1")',
      :create     => 'post(:create, :account_id => "1")',
      :edit       => 'get(:edit, :account_id => "1", :id => "2")',
      :update     => 'put(:update, :account_id => "1", :id => "2")',
      :destroy    => 'delete(:destroy, :account_id => "1", :id => "2")',
      :complete   => 'put(:complete, :account_id => "1", :id=>"2")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        eval code
      end
    end
  end
end
