class SectionsController < ApplicationController
  before_filter :get_project, :only => [:index, :new, :create]
  before_filter :get_section_and_project, :only => [:show, :edit, :update, :destroy]
  before_filter :check_permissions
  
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
  
  private
    def get_project
      @project = Project.find(params[:project_id])
    end
    
    def get_section_and_project
      @section = Section.find(params[:id])
      @project = @section.project
    end
    
    def check_permissions
      unless @project.involves? current_user
        deny_access
      end
    end
end
