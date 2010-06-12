class TasksController < ApplicationController
  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @section = Section.find(params[:section_id])
    @task    = @section.tasks.build(params[:task])

    if @task.save
      redirect_to [@section.project, @section]
    else
      render :action => "new"
    end
  end
  
  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      redirect_to @task
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to [@task.section.project, @task.section]
  end
end
