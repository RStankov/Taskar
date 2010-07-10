class ProjectsController < ApplicationController
  before_filter :check_for_admin
  before_filter :get_project, :only => [:show, :edit, :update, :destroy, :complete]
  
  def index
    @projects  = Project.active
    @completed = Project.completed
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(params[:project])

    if @project.save
      redirect_to @project
    else
      render :action => "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to @project
    else
      render :action => "edit"
    end
  end

  def destroy
    @project.destroy

    redirect_to projects_url
  end
  
  def complete
    @project.completed = params[:complete] ? true : false
    @project.save
    
    redirect_to @project
  end
  
  private
    def get_project
      @project = Project.find(params[:id])
    end
end
