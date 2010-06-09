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
  end

  describe "GET index" do
    it "assigns all sections as @sections" do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return([mock_section])
      get :index, :project_id => "1"
      assigns[:sections].should == [mock_section]
    end
  end

  describe "GET show" do
    before do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return(Section)
    end
      
    it "assigns the requested section as @section" do
      Section.stub(:find).with("37").and_return(mock_section)
      get :show, :id => "37", :project_id => "1"
      assigns[:section].should equal(mock_section)
    end
  end

  describe "GET new" do
    it "assigns a new section as @section" do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return(Section)
      Section.stub(:build).and_return(mock_section)
      get :new, :project_id => "1"
      assigns[:section].should equal(mock_section)
    end
  end

  describe "GET edit" do
    before do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return(Section)
    end
    
    it "assigns the requested section as @section" do
      Section.stub(:find).with("37").and_return(mock_section)
      get :edit, :id => "37", :project_id => "1"
      assigns[:section].should equal(mock_section)
    end
  end

  describe "POST create" do
    before do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return(Section)
    end

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
    before do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return(Section)
    end
    
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
    before do
      Project.stub(:find).with("1").and_return(mock_project)
      mock_project.should_receive(:sections).and_return(Section)
    end
    
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
