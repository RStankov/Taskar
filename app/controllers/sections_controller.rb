class SectionsController < ApplicationController
  before_filter :get_project, :only => [:index, :new, :create, :reorder, :tasks, :archived]
  before_filter :get_section_and_project, :only => [:show, :edit, :update, :destroy, :archive]
  before_filter :check_project_permissions

  def index
    project_user.event_seen!

    @events = @project.events.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @tasks = @section.current_tasks
  end

  def new
    @section = @project.sections.build
  end

  def edit
  end

  def create
    @section = @project.sections.build(params[:section])

    if @section.save
      redirect_to @section
    else
      render :action => "new"
    end
  end

  def update
    if @section.update_attributes(params[:section])
      if request.xhr?
        render :action => "show"
      else
        redirect_to @section
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @section.destroy

    redirect_to [:tasks, @project, :sections]
  end

  def reorder
    @project.sections.reorder(params[:items])

    head :ok
  end

  def archive
    @section.archived = params[:archive] == 'true'
    @section.save

    redirect_to @section
  end

  def archived
    @sections = @project.sections.archived
  end

  def tasks
    @section = @project.sections.unarchived.first

    redirect_to @section || [:new, @project, :section]
  end

  private
    def get_section_and_project
      @section = Section.find(params[:id])
      @project = @section.project
    end
end
