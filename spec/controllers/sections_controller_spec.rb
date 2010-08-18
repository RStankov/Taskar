require 'spec_helper'

describe SectionsController do
  describe "with project user" do
    before { sign_with_project_user }
    
    context "member action" do
      before { Section.stub(:find).with("1").and_return mock_section }     
       
      describe "GET show" do
        before { mock_section.should_receive(:current_tasks).and_return [mock_task] }

        context "normal format" do
          before { get :show, :id => "1" }
          
          it { should assign_to(:project).with(mock_project) }
          it { should assign_to(:section).with(mock_section) }
          it { should assign_to(:tasks).with([mock_task])    }
          it { should render_template("show.html")           }
        end

        context "print version" do
          before { get :show, :id => "1", :format => "print" }
          
          it { should assign_to(:section).with(mock_section) }
          it { should assign_to(:project).with(mock_project) }
          it { should assign_to(:tasks).with([mock_task])    }
          it { should render_template("show.print")         }
        end

      end
      
      describe "GET edit" do
        before { get :edit, :id => "1" }
        
        it { should assign_to(:project).with(mock_project) }
        it { should assign_to(:section).with(mock_section) }
        it { should render_template("edit.html")           }
      end
      
      describe "PUT update, with valid params" do
        before do
          mock_section.should_receive(:update_attributes).with({'these' => 'params'}).and_return true

          put :update, :id => "1", :section => {:these => 'params'}
        end
        
        it { should assign_to(:project).with(mock_project) }
        it { should assign_to(:section).with(mock_section) }
        it { should redirect_to(section_url(mock_section)) }
      end

      describe "PUT update, with invalid params" do
        before do
          mock_section.should_receive(:update_attributes).with({'these' => 'params'}).and_return false

          put :update, :id => "1", :section => {:these => 'params'}
        end
        
        it { should assign_to(:project).with(mock_project) }
        it { should assign_to(:section).with(mock_section) }
        it { should render_template("edit.html")           }
      end

      describe "DELETE destroy" do
        before do
          mock_section.should_receive(:destroy)

          delete :destroy, :id => "1"        
        end

        it { should assign_to(:project).with(mock_project)          }
        it { should assign_to(:section).with(mock_section)          }
        it { should redirect_to(project_sections_url(mock_project)) }
      end

      describe "PUT archive" do
        before do
          mock_section.should_receive(:save)
          mock_section.should_receive(:archived=).with "true"
          
          put :archive, :id => "1", :archive => "true"
        end
        
        it { should redirect_to(section_url(mock_section)) }
      end
    
    end
    
    context "Project section action" do
      before { Project.stub(:find).with("1").and_return mock_project }
      
      describe "GET index" do
        before do
          mock_project.stub!(:events).and_return @events = [mock_event]
          @events.should_receive(:paginate).with(:page => "1", :per_page => 30).and_return @events

          controller.stub!(:project_user).and_return mock_project_user
          mock_project_user.should_receive :event_seen!

          get :index, :project_id => "1", :page => "1"
        end

        it { should assign_to(:events).with(@events) }
        it { should assign_to(:project).with(@project) }
        it { should render_template("index") }
      end
      
      describe "GET new" do
        before do
          mock_project.stub_chain :sections, :build => mock_section

          get :new, :project_id => "1"
        end
        
        it { should assign_to(:project).with(mock_project) }
        it { should assign_to(:section).with(mock_section) }
        it { should render_template("new")                 }
      end

      describe "POST create, with valid params" do
        before do
          mock_project.should_receive(:sections).and_return Section
          Section.stub(:build).with({'these' => 'params'}).and_return mock_section(:save => true)

          post :create, :section => {:these => 'params'}, :project_id => "1"
        end

        it { should assign_to(:project).with(mock_project) }
        it { should assign_to(:section).with(mock_section) }
        it { should redirect_to(section_url(mock_section)) }
      end

      describe "POST create, with invalid params" do
        before do
          mock_project.should_receive(:sections).and_return Section
          Section.stub(:build).with({'these' => 'params'}).and_return mock_section(:save => false)

          post :create, :section => {:these => 'params'}, :project_id => "1"
        end

        it { should assign_to(:project).with(mock_project)  }
        it { should assign_to(:section).with(mock_section)  }
        it { should render_template('new')                  }
      end
  
      describe "GET tasks, with at least one section in the project" do
        before do
          mock_project.stub_chain :sections, :unarchived, :first => mock_section

          get :tasks, :project_id => "1"
        end

        it { should redirect_to(section_url(mock_section))}
      end

      describe "GET tasks, without section in the project " do
        before do
          mock_project.stub_chain :sections, :unarchived, :first => nil

          get :tasks, :project_id => "1"
        end

        it { should redirect_to(new_project_section_url(mock_project)) }
      end
  
      describe "PUT reorder" do
        before do
          mock_project.should_receive(:sections).and_return Section
          Section.should_receive(:reorder).with ["1", "2", "3", "4"]
          
          xhr :put, :reorder, :project_id => "1", :items => ["1", "2", "3", "4"]
        end

        it { should_not render_template("reorder") }
        it { response.should be_success }
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
      :reorder    => 'put(:reorder, :project_id => "1")',
      :tasks      => 'get(:tasks, :project_id => "1")'
    }.each do |(action, code)|
     it "should not allow #{action}, and redirect_to root_url" do
       Project.should_receive(:find).with("1").and_return(mock_project)
      
       eval code
     end
    end
  end

end
