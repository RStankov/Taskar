require 'spec_helper'

describe SectionsController do

  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, {:project => mock_project}.merge(stubs))
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  describe "with project user" do
    before do
      user = Factory(:user)
      sign_in user
      mock_project.should_receive(:involves?).with(user).and_return(true)
    end
    
    describe "GET index" do
      before do
        Project.stub(:find).with("1").and_return(mock_project)
        mock_project.should_receive(:sections).and_return(Section)

        get :index, :project_id => "1"
      end

      it "assigns project sections as @sections" do
        assigns[:sections].should == Section
      end

      it "assigns project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "GET show" do
      before do
        Section.stub(:find).with("37").and_return(mock_section)
        get :show, :id => "37"
      end

      it "assigns the requested section as @section" do
        assigns[:section].should == mock_section
      end

      it "assigns project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "GET new" do
      before do
        Project.stub(:find).with("1").and_return(mock_project)
        mock_project.should_receive(:sections).and_return(Section)

        Section.stub(:build).and_return(mock_section)

        get :new, :project_id => "1"
      end

      it "assigns a new section as @section" do
        assigns[:section].should equal(mock_section)
      end

      it "assigns project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "GET edit" do
      before do
        Section.stub(:find).with("37").and_return(mock_section)
        get :edit, :id => "37"
      end

      it "assigns the requested section as @section" do
        assigns[:section].should == mock_section
      end

      it "assigns project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "POST create" do
      before do
        Project.stub(:find).with("1").and_return(mock_project)
        mock_project.should_receive(:sections).and_return(Section)
      end

      describe "with valid params" do
        before do
          Section.stub(:build).with({'these' => 'params'}).and_return(mock_section(:save => true))
          post :create, :section => {:these => 'params'}, :project_id => "1"
        end

        it "assigns a newly created section as @section" do
          assigns[:section].should equal(mock_section)
        end

        it "redirects to the created section" do
          response.should redirect_to(section_url(mock_section))
        end

        it "assigns project as @project" do
          assigns[:project].should == mock_project
        end
      end

      describe "with invalid params" do
        before do
          Section.stub(:build).with({'these' => 'params'}).and_return(mock_section(:save => false))
          post :create, :section => {:these => 'params'}, :project_id => "1"
        end

        it "assigns a newly created but unsaved section as @section" do
          assigns[:section].should equal(mock_section)
        end

        it "re-renders the 'new' template" do
          response.should render_template('new')
        end

        it "assigns project as @project" do
          assigns[:project].should == mock_project
        end
      end

    end

    describe "PUT update" do
      describe "with valid params" do
        before do
          Section.should_receive(:find).with("1").and_return(mock_section)
          mock_section.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)

          put :update, :id => "1", :section => {:these => 'params'}
        end

        it "updates the requested section" do
        end

        it "assigns the requested section as @section" do
          assigns[:section].should equal(mock_section)
        end

        it "redirects to the section" do
          response.should redirect_to(section_url(mock_section))
        end

        it "assigns project as @project" do
          assigns[:project].should == mock_project
        end
      end

      describe "with invalid params" do
        before do
          Section.should_receive(:find).with("37").and_return(mock_section)
          mock_section.should_receive(:update_attributes).with({'these' => 'params'}).and_return(false)

          put :update, :id => "37", :section => {:these => 'params'}
        end

        it "assigns the section as @section" do
          assigns[:section].should equal(mock_section)
        end

        it "re-renders the 'edit' template" do
          response.should render_template(:edit)
        end

        it "assigns project as @project" do
          assigns[:project].should == mock_project
        end
      end

    end

    describe "DELETE destroy" do
      before do
        Section.should_receive(:find).with("1").and_return(mock_section)
        mock_section.should_receive(:destroy)
      end

      it "destroys the requested section" do
        delete :destroy, :id => "1"
      end

      it "redirects to the sections list" do
        delete :destroy, :id => "1"
        response.should redirect_to(project_sections_url(mock_project))
      end

      it "assigns project as @project" do
        delete :destroy, :id => "1"
        assigns[:project].should == mock_project
      end
    end

  end
  
  describe "with user outside project" do
    before do
      user = Factory(:user)
      sign_in user
      mock_project.should_receive(:involves?).with(user).and_return(false)
      
      ensure_deny_access_is_called
    end
    
    {
      :show       => 'get(:show, :id => "1")',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
      :destroy    => 'delete(:destroy, :id => "1")'
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        Section.should_receive(:find).with("1").and_return(mock_section)
        
        eval code
      end
    end
    
    {
      :index      => 'get(:index, :project_id => "1")',
      :create     => 'post(:create, :project_id => "1")',
      :new        => 'get(:new, :project_id => "1")',
    }.each do |(action, code)|
     it "should not allow #{action}, and redirect_to root_url" do
       Project.should_receive(:find).with("1").and_return(mock_project)
      
       eval code
     end
    end
  end

end
