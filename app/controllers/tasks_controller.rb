class TasksController < ApplicationController
  layout "sections"

  before_filter :get_task_and_project, :only => [:show, :edit, :update, :destroy, :state, :archive, :section]
  before_filter :get_section_and_project, :only => [:create, :archived]
  before_filter :get_project, :only => [:index, :search, :reorder]
  before_filter :check_project_permissions
  before_filter :ensure_task_is_editable, :only => [:edit, :update]

  def index
    @tasks = current_user.responsibilities.opened_in_project(@project)
  end

  def show
    @section = @task.section
  end

  def edit
    redirect_to @task unless request.xhr?
  end

  def create
    @task = current_user.new_task(@section, params[:task])

    if @task.save
      event

      unless request.xhr?
        redirect_to section_path(@section, :anchor => "task_#{@task.id}")
      else
        render
      end
    else
      render :partial => "new.js"
    end
  end

  def update
    if @task.update_attributes(params[:task])
      event

      if request.xhr?
        render :action => "show"
      else
        redirect_to @task
      end
    else
      render :action => "edit.js"
    end
  end

  def destroy
    @task.destroy

    event

    if request.xhr?
      head :ok
    else
      redirect_to @task.section
    end
  end

  def state
    @task.state = params[:state]
    @task.save

    event

    head :ok
  end

  def archive
     @task.toggle_archived

     event

     head :ok
  end

  def reorder
    @project.tasks.reorder(params[:items])

    head :ok
  end

  def search
    search_proxy = @project.tasks.unarchived.search(params[:ss])

    @limit = 20
    @tasks = search_proxy.limit @limit
    @total = search_proxy.count

    render :layout => false
  end

  def archived
    @tasks = @section.tasks.archived

    render :layout => false
  end

  def section
    @task.update_attribute :section_id, params[:section_id]
    @task.move_to_top

    head :ok
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

    def ensure_task_is_editable
      unless @task.editable?
        if request.xhr?
          render :action => "show"
        else
          redirect_to @task
        end
      end
    end

    def event
      activity(@task)
    end
end