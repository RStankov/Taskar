class TasksController < ApplicationController
  layout "sections"
  
  before_filter :get_task_and_project, :only => [:show, :edit, :update, :destroy, :state, :archive]
  before_filter :get_section_and_project, :only => [:create, :archived]
  before_filter :get_project, :only => [:search, :reorder]
  before_filter :check_project_permissions
  
  def show
    @section = @task.section
  end

  def edit
  end

  def create
    @task = current_user.new_task(@section, params[:task])

    if @task.save
      event :opened
      
      unless request.xhr?
        redirect_to section_path(@section, :anchor => "task_#{@task.id}")
      else
        render
      end
    else
      render :partial => "new"
    end
  end
  
  def update
    if @task.update_attributes(params[:task])
      event :opened
      
      if request.xhr?
        render :action => "show"
      else
        redirect_to @task
      end
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @task.destroy
    
    event :deleted

    if request.xhr?
      head :ok
    else
      redirect_to @task.section
    end
  end
  
  def state
    @task.state = params[:state]
    @task.save
    
    head :ok
  end
  
  def archive
     @task.archived = params[:archived] ? true : false
     @task.save
     
     head :ok
  end
  
  def reorder
    @project.tasks.reorder(params[:items])
    
    head :ok
  end
  
  def search
    @tasks = @project.tasks.unarchived.search(params[:ss])
    
    render :layout => false
  end
  
  def archived
    @tasks = @section.tasks.archived
    
    render :layout => false
  end

  private
    def get_task_and_project
      @task    = Task.find(params[:id])
      @project = @task.project
    end
    
    def get_section_and_project
      @section = Section.find(params[:section_id])
      @project = @section.project
    end
    
    def get_project
      @project = Project.find(params[:project_id])
    end   

    def event(action)
      activity(action, @task)
    end
end