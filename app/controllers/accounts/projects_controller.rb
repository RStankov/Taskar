class Accounts::ProjectsController < Accounts::BaseController
  before_filter :get_project, :only => [:show, :edit, :update, :destroy, :complete]

  def index
    @projects  = projects.active
    @completed = projects.completed
  end

  def show
    @sections = @project.sections.order("position ASC")
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
      render "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to [@account, @project]
    else
      render "edit"
    end
  end

  def destroy
    @project.destroy

    redirect_to [@account, :projects]
  end

  def complete
    @project.completed = params[:complete] ? true : false
    @project.save

    redirect_to [@account, @project]
  end

  private
    def projects
      @account.projects
    end

    def get_project
      @project = projects.find(params[:id])
    end
end
