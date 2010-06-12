require 'spec_helper'

describe SectionsController do

  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, stubs)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  before do
    sign_in Factory(:user)
    
    Project.stub(:find).with("1").and_return(mock_project)
    mock_project.should_receive(:sections).and_return(Section)
  end

  describe "GET index" do
    it "assigns project sections as @sections" do
      get :index, :project_id => "1"
      assigns[:sections].should == Section
    end
  end

  describe "GET show" do
    it "assigns the requested section as @section" do
      Section.stub(:find).with("37").and_return(mock_section)
      get :show, :id => "37", :project_id => "1"
      assigns[:section].should equal(mock_section)
    end
  end

  describe "GET new" do
    it "assigns a new section as @section" do
      Section.stub(:build).and_return(mock_section)
      get :new, :project_id => "1"
      assigns[:section].should equal(mock_section)
    end
  end

  describe "GET edit" do    
    it "assigns the requested section as @section" do
      Section.stub(:find).with("37").and_return(mock_section)
      get :edit, :id => "37", :project_id => "1"
      assigns[:section].should equal(mock_section)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created section as @section" do
        Section.stub(:build).with({'these' => 'params'}).and_return(mock_section(:save => true))
        post :create, :section => {:these => 'params'}, :project_id => "1"
        assigns[:section].should equal(mock_section)
      end

      it "redirects to the created section" do
        Section.stub(:build).and_return(mock_section(:save => true))
        post :create, :section => {}, :project_id => "1"
        response.should redirect_to(project_section_url(mock_project, mock_section))
      end
      
      it "calls also move_after if after params is given" do
        Section.stub(:build).and_return(mock_section(:save => true))
        mock_section.should_receive(:move_after).with("foo").and_return(true)
        post :create, :section => {}, :project_id => "1", :after => "foo"
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved section as @section" do
        Section.stub(:build).with({'these' => 'params'}).and_return(mock_section(:save => false))
        post :create, :section => {:these => 'params'}, :project_id => "1"
        assigns[:section].should equal(mock_section)
      end

      it "re-renders the 'new' template" do
        Section.stub(:build).and_return(mock_section(:save => false))
        post :create, :section => {}, :project_id => "1"
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested section" do
        Section.should_receive(:find).with("37").and_return(mock_section)
        mock_section.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :section => {:these => 'params'}, :project_id => "1"
      end

      it "assigns the requested section as @section" do
        Section.stub(:find).and_return(mock_section(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        assigns[:section].should equal(mock_section)
      end

      it "redirects to the section" do
        Section.stub(:find).and_return(mock_section(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        response.should redirect_to(project_section_url(mock_project, mock_section))
      end
    end

    describe "with invalid params" do
      it "updates the requested section" do
        Section.should_receive(:find).with("37").and_return(mock_section)
        mock_section.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :section => {:these => 'params'}, :project_id => "1"
      end

      it "assigns the section as @section" do
        Section.stub(:find).and_return(mock_section(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        assigns[:section].should equal(mock_section)
      end

      it "re-renders the 'edit' template" do
        Section.stub(:find).and_return(mock_section(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested section" do
      Section.should_receive(:find).with("37").and_return(mock_section(:project_id => 1))
      mock_section.should_receive(:destroy)
      delete :destroy, :id => "37", :project_id => "1"
    end

    it "redirects to the sections list" do
      Section.stub(:find).and_return(mock_section(:destroy => true, :project_id => 1))
      delete :destroy, :id => "1", :project_id => "1"
      response.should redirect_to(project_sections_url(mock_project))
    end
  end

end
