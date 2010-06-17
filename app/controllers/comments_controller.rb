class CommentsController < ApplicationController
  def edit
    @comment = Comment.find(params[:id])
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
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      redirect_to_comment
    else
      render :action => "edit"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    
    if request.xhr?
      head :ok
    else
      redirect_to task_path(@comment.task, :anchor => "new_comment")
    end
  end
  
  private 
    def redirect_to_comment
      redirect_to task_path(@comment.task, :anchor => "comment_#{@comment.id}")
    end
end
