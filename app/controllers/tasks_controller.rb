class TasksController < ApplicationController
  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])

    if @task.save
      redirect_to(@task, :notice => 'Task was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      redirect_to(@task, :notice => 'Task was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to(project_section_path(@task.section.project, @task.section))
  end
end
