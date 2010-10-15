class ProjectsController < ApplicationController
  layout "admin"

  before_filter :check_for_admin
  before_filter :get_project, :only => [:show, :edit, :update, :destroy, :complete]

  def index
    @projects  = account.projects.active
    @completed = account.projects.completed
  end

  def show
    @sections = @project.sections.order("position ASC")
  end

  def new
    @project = account.projects.build
  end

  def edit
  end

  def create
    @project = account.projects.build(params[:project])

    if @project.save
      redirect_to [account, @project]
    else
      render :action => "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to [account, @project]
    else
      render :action => "edit"
    end
  end

  def destroy
    @project.destroy

    redirect_to [account, :projects]
  end

  def complete
    @project.completed = params[:complete] ? true : false
    @project.save

    redirect_to [account, @project]
  end

  private
    def get_project
      @project = account.projects.find(params[:id])
    end
end
