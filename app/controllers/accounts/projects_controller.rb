class Accounts::ProjectsController < Accounts::BaseController
  layout 'projects'

  def index
  end

  def show
    @project = find_project
  end

  def new
    @project = projects.build
  end

  def edit
    @project = find_project
  end

  def create
    @project = projects.build(params[:project])

    if @project.save
      redirect_to tasks_project_sections_path(@project)
    else
      render 'new'
    end
  end

  def update
    @project = find_project

    if @project.update_attributes(params[:project])
      redirect_to account_project_path(@account, @project), :notice => 'Project updated successfully'
    else
      render 'edit'
    end
  end

  def destroy
    project = find_project
    project.destroy

    redirect_to account_projects_path(@account)
  end

  def complete
    project = find_project
    project.completed = params[:complete] == 'true'
    project.save

    redirect_to account_project_path(@account, project), :notice => project.completed ? 'Project completed successfully' : 'Project has been reset'
  end

  private

  def projects
    @account.projects
  end

  def find_project
    projects.find(params[:id])
  end
end
