class Accounts::ProjectsController < Accounts::BaseController
  before_filter :get_project, :only => [:show, :edit, :update, :destroy, :complete]

  def index
  end

  def show
  end

  def new
    @project = projects.build
  end

  def edit
  end

  def create
    @project = projects.build(params[:project])

    if @project.save
      redirect_to [:tasks, @project, :sections]
    else
      render 'new'
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to [@account, @project], :notice => 'Project updated successfully'
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy

    redirect_to [@account, :projects]
  end

  def complete
    @project.completed = params[:complete] == 'true'
    @project.save

    redirect_to [@account, @project], :notice => @project.completed ? 'Project completed successfully' : 'Project has been reset'
  end

  private
    def projects
      @account.projects
    end

    def get_project
      @project = projects.find(params[:id])
    end
end
