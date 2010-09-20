class CommentsController < ApplicationController
  before_filter :get_comment_and_project, :except => [:create]
  before_filter :get_task_and_project, :only => [:create]
  before_filter :check_project_permissions
  before_filter :ensure_comment_is_editable, :only => [:edit, :update, :destroy]

  def show
    redirect_to_comment unless request.xhr?
  end

  def edit
    redirect_to_comment unless request.xhr?
  end

  def create
    @comment = current_user.new_comment(@task, params[:comment])

    if @comment.save
      render_or_redirect_after_event
    else
      render :action => "new"
    end
  end

  def update
    if @comment.update_attributes(params[:comment])
      render_or_redirect_after_event
    else
      render :action => "edit"
    end
  end

  def destroy
    @comment.destroy

    event

    redirect_to @comment.task unless request.xhr?
  end

  private
    def get_comment_and_project
      @comment = Comment.find(params[:id])
      @project = @comment.project
    end

    def get_task_and_project
      @task = Task.find(params[:task_id])
      @project = @task.project
    end

    def ensure_comment_is_editable
      unless @comment.editable_by?(current_user)
        if request.xhr?
          head :bad_request
        else
          redirect_to_comment
        end
      end
    end

    def event
      activity(@comment)
    end

    def redirect_to_comment
      redirect_to task_path(@comment.task, :anchor => "comment_#{@comment.id}")
    end

    def render_or_redirect_after_event
      event

      if request.xhr?
        render :action => "show"
      else
        redirect_to_comment
      end
    end
end
