class CommentsController < ApplicationController
  before_filter :get_comment, :except => [:create]
  before_filter :ensure_comment_is_editable, :only => [:edit, :update, :destroy]
  
  def show
    redirect_to_comment unless request.xhr?
  end
  
  def edit
  end

  def create
    @comment = current_user.new_comment(Task.find(params[:task_id]), params[:comment])

    if @comment.save
      redirect_to_comment
    else
      render :action => "new"
    end
  end

  def update
    if @comment.update_attributes(params[:comment])
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
    
    if request.xhr?
      head :ok
    else
      redirect_to task_path(@comment.task)
    end
  end
  
  private 
    def get_comment
      @comment = Comment.find(params[:id])
    end
    
    def ensure_comment_is_editable
      unless @comment.editable_by(current_user)
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
end
