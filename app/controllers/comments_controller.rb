class CommentsController < ApplicationController
  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Task.find(params[:task_id]).comments.build(params[:comment]) 

    if @comment.save
      redirect_to @comment.task
    else
      render :action => "new"
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      redirect_to @comment.task
    else
      render :action => "edit"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to @comment.task
  end
end
