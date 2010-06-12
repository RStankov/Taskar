class SectionsController < ApplicationController
  before_filter :get_project
  
  def index
    @sections = @project.sections
  end

  def show
    @section = @project.sections.find(params[:id])
  end

  def new
    @section = @project.sections.build
  end
  
  def edit
    @section = @project.sections.find(params[:id])
  end

  def create
    @section = @project.sections.build(params[:section])

    if @section.save
      @section.move_after params[:after] if params[:after]  
      redirect_to [@project, @section], :notice => 'Section was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @section = @project.sections.find(params[:id])
    
    if @section.update_attributes(params[:section])
      redirect_to [@project, @section], :notice => 'Section was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    section = @project.sections.find(params[:id])
    section.destroy
    
    redirect_to project_sections_path(@project)
  end
  
  private
    def get_project
      @project = Project.find(params[:project_id])
    end
end
