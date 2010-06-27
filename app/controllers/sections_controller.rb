class SectionsController < ApplicationController
  before_filter :get_project, :only => [:index, :new, :create, :reorder]
  before_filter :get_section_and_project, :only => [:show, :edit, :update, :destroy, :aside]
  before_filter :check_project_permissions
  
  def index
    @sections = @project.sections
  end

  def show
  end

  def new
    @section = @project.sections.build
  end
  
  def edit
  end

  def create
    @section = @project.sections.build(params[:section])
    
    if @section.save
      redirect_to @section
    else
      render :action => "new"
    end
  end

  def update
    if @section.update_attributes(params[:section])
      redirect_to @section
    else
      render :action => "edit"
    end
  end

  def destroy
    @section.destroy
    
    redirect_to project_sections_path(@section.project)
  end
  
  def reorder
    @project.sections.reorder(params[:items])
    
    head :ok
  end
  
  def aside
    render :json => {:responsibilities_count => current_user.responsibilities_count}
  end
  
  private
    def get_project
      @project = Project.find(params[:project_id])
    end
    
    def get_section_and_project
      @section = Section.find(params[:id])
      @project = @section.project
    end
end
