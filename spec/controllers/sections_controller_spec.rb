require 'spec_helper'

describe SectionsController do
  describe "with project user" do
    before { sign_with_project_user }
    
    describe "GET index" do
      before do
        Project.stub(:find).with("1").and_return(mock_project)
        mock_project.stub!(:events).and_return(@events = [mock_event])
        @events.should_receive(:paginate).with(:page => "1", :per_page => 30).and_return(@events)

        get :index, :project_id => "1", :page => "1"
      end

      it "assigns paginated events as @events" do
        assigns[:events].should == @events
      end
     

      it "assigns project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "GET show" do
      before do
        Section.stub(:find).with("37").and_return(mock_section(:archived? => false))
      end
      
      describe "normal format" do
        before do          
          get :show, :id => "37"
        end
        
        it "assigns the requested section as @section" do
          assigns[:section].should == mock_section
        end

        it "assigns project as @project" do
          assigns[:project].should == mock_project
        end
        
        it { should render_template("show.html") }
      end
      
      describe "print version" do
        before do
          get :show, :id => "37", :format => "print"
        end
        
        it { should render_template("show.print") }
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
        
        delete :destroy, :id => "1"        
      end

      it "destroys the requested section" do
      end

      it "redirects to the sections list" do
        response.should redirect_to(project_sections_url(mock_project))
      end

      it "assigns project as @project" do
        assigns[:project].should == mock_project
      end
    end

    describe "PUT reorder" do
      before do
        Project.should_receive(:find).with("1").and_return(mock_project)
        mock_project.should_receive(:sections).and_return(Section)
      end

      it "should call reorder the given ids" do
        Section.should_receive(:reorder).with(["1", "2", "3", "4"])

        xhr :put, :reorder, :project_id => "1", :items => ["1", "2", "3", "4"]
      end

      it "should not render template" do
        xhr :put, :reorder, :project_id => "1"

        response.should_not render_template(:reorder)
        response.should be_success
      end
    end
  
    describe "PUT archive" do
      before do
        Section.stub!(:find).with("1").and_return(mock_section(:save => nil))
        mock_section.stub!(:archived=)
      end
      
      it "should set archived= to params[:archive]" do
        mock_section.should_receive(:archived=).with("true")
        
        put :archive, :id => "1", :archive => "true"
      end
      
      it "should redirect to archived section" do
        put :archive, :id => "1", :archive => "true"
        
        response.should redirect_to(section_url(mock_section))
      end
    end
  end
  
  describe "with user outside project" do
    before { sign_with_user_outside_the_project }
    
    {
      :show       => 'get(:show, :id => "1")',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
      :destroy    => 'delete(:destroy, :id => "1")',
      :archive    => 'put(:archive, :id => "1")'
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
      :reorder    => 'put(:reorder, :project_id => "1")'
    }.each do |(action, code)|
     it "should not allow #{action}, and redirect_to root_url" do
       Project.should_receive(:find).with("1").and_return(mock_project)
      
       eval code
     end
    end
  end

end
