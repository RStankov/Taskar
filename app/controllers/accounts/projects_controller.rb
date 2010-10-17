class Accounts::ProjectsController < ApplicationController
  layout "admin"

  before_filter :get_account
  before_filter :check_for_account_admin
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
      redirect_to [@account, @project]
    else
      render :action => "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to [@account, @project]
    else
      render :action => "edit"
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
    def get_account
      @account = Account.find(params[:account_id])
    end

    def check_for_account_admin
      unless @account.admin? current_user
        deny_access
      end
    end

    def projects
      @account.projects
    end

    def get_project
      @project = projects.find(params[:id])
    end
end
