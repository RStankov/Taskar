class TasksController < ApplicationController
  layout "sections"
  
  def show
    @task    = Task.find(params[:id])
    @section = @task.section
    @project = @section.project
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @section = Section.find(params[:section_id])
    @task    = @section.tasks.build(params[:task])

    if @task.save
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
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
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
    @task = Task.find(params[:id])
    @task.destroy

    if request.xhr?
      head :ok
    else
      redirect_to @task.section
    end
  end
  
  def state
    @task = Task.find(params[:id])
    @task.state = params[:state]
    @task.save
    
    head :ok
  end
  
  def reorder 
    Task.reorder(params[:items])
    
    head :ok
  end
  
  def search
    @tasks = Task.search(params[:ss])
    
    render :search, :layout => false
  end
  
  def archive 
     @task = Task.find(params[:id])
     @task.archived = params[:archived]
     @task.save
     
     if request.xhr?
       head :ok
     else
       redirect_to @task.section
     end 
  end
end
