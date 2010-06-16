require 'spec_helper'

describe CommentsController do

  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, {:task => mock_task}.merge(stubs))
  end
  
  def mock_task(stubs={})
    @mock_task ||= mock_model(Task, {:section => mock_section, :project => mock_project}.merge(stubs))
  end
  
  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, {:project => mock_project}.merge(stubs))
  end

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  before do
    sign_in Factory(:user)
  end

  describe "POST create" do
    before do
      Task.should_receive(:find).with("1").and_return(mock_task)
      
      def controller.current_user
        @current_user ||= Factory(:user)
      end
      
      controller.current_user.should_receive(:new_comment).with(mock_task, {"these" => "params"}).and_return(mock_comment)
    end

    describe "with valid params" do
      before do
        mock_comment.stub!(:save).and_return(true)
      
        post :create, :comment => {:these => 'params'}, :task_id => "1"
      end
      
      it "assigns a newly created comment as @comment" do
        assigns[:comment].should equal(mock_comment)
      end

      it "redirects to the created comment" do
        response.should redirect_to(task_url(mock_comment.task, :anchor => "comment_#{mock_comment.id}"))
      end
    end

    describe "with invalid params" do
      before do
        mock_comment.stub!(:save).and_return(false)
                
        post :create, :comment => {:these => 'params'}, :task_id => "1"
      end
      
      it "assigns a newly created but unsaved comment as @comment" do
        assigns[:comment].should equal(mock_comment)
      end

      it "re-renders the 'new' template" do
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested comment" do
        Comment.should_receive(:find).with("37").and_return(mock_comment)
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :comment => {:these => 'params'}
      end

      it "assigns the requested comment as @comment" do
        Comment.should_receive(:find).and_return(mock_comment(:update_attributes => true))
        put :update, :id => "1"
        assigns[:comment].should equal(mock_comment)
      end

      it "redirects to the comment" do
        Comment.should_receive(:find).and_return(mock_comment(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(task_url(mock_comment.task, :anchor => "comment_#{mock_comment.id}"))
      end
    end

    describe "with invalid params" do
      it "updates the requested comment" do
        Comment.should_receive(:find).with("37").and_return(mock_comment)
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :comment => {:these => 'params'}
      end

      it "assigns the comment as @comment" do
        Comment.stub(:find).and_return(mock_comment(:update_attributes => false))
        put :update, :id => "1"
        assigns[:comment].should equal(mock_comment)
      end

      it "re-renders the 'edit' template" do
        Comment.stub(:find).and_return(mock_comment(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested comment" do
      Comment.should_receive(:find).with("37").and_return(mock_comment)
      mock_comment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the comments list" do
      Comment.stub(:find).and_return(mock_comment(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(task_url(mock_comment.task, :anchor => "new_comment"))
    end
  end

end
