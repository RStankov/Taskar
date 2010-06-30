class CommentsController < ApplicationController
  before_filter :get_comment_and_project, :except => [:create]
  before_filter :get_task_and_project, :only => [:create] 
  before_filter :check_project_permissions
  before_filter :ensure_comment_is_editable, :only => [:edit, :update, :destroy]
  
  def show
    redirect_to_comment unless request.xhr?
  end
  
  def edit
  end

  def create
    @comment = current_user.new_comment(@task, params[:comment])

    if @comment.save
      event
      
      if request.xhr?
        render :action => "show"
      else
        redirect_to_comment
      end
    else
      render :action => "new"
    end
  end

  def update
    if @comment.update_attributes(params[:comment])
      event
      
      if request.xhr?
        render :action => "show"
      else
        redirect_to_comment
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @comment.destroy
    
    event
    
    if request.xhr?
      head :ok
    else
      redirect_to @comment.task
    end
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

    def redirect_to_comment
      redirect_to task_path(@comment.task, :anchor => "comment_#{@comment.id}")
    end

    def event
      activity(@comment)
    end
end
