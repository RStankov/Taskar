class SectionsController < ApplicationController
  before_filter :get_project, :only => [:index, :new, :create]
  
  def index
    @sections = @project.sections
  end

  def show
    @section = Section.find(params[:id])
    @project = @section.project
  end

  def new
    @section = @project.sections.build
  end
  
  def edit
    @section = Section.find(params[:id])
    @project = @section.project
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
    @section = Section.find(params[:id])
    
    if @section.update_attributes(params[:section])
      redirect_to @section
    else
      render :action => "edit"
    end
  end

  def destroy
    section = Section.find(params[:id])
    section.destroy
    
    redirect_to project_sections_path(section.project)
  end
  
  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
