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
  
  describe "GET show" do
    before do
      Comment.should_receive(:find).with("1").and_return(mock_comment)
    end
    
    it "assign retrieved comment as @comment" do
      get :show, :id => "1"
      assigns[:comment].should == mock_comment
    end
    
    it "renders show action on xhr" do
      xhr :get, :show, :id => "1"
      response.should render_template('show')
    end
    
    it "redirects to comment page on non xhr request" do
      get :show, :id => "1"
      response.should redirect_to(task_url(mock_comment.task, :anchor => "comment_#{mock_comment.id}"))
    end
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
    before do
      Comment.should_receive(:find).with("1").and_return(mock_comment)
    end

    def params
      {:id => "1", :comment => {:these => 'params'}}
    end

    describe "with valid params" do
      before do
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
      end
      
      it "updates the requested comment" do
        xhr :put, :update, params
      end

      it "assigns the requested comment as @comment" do
        xhr :put, :update, params
        assigns[:comment].should equal(mock_comment)
      end
      
      it "renders show action if this is xhr request" do
        xhr :put, :update, params
        response.should render_template('show')
      end

      it "redirects to the comment if not xhr request" do
        put :update, params
        response.should redirect_to(task_url(mock_comment.task, :anchor => "comment_#{mock_comment.id}"))
      end
    end

    describe "with invalid params" do
      before do
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(false)
      end
    
      it "updates the requested comment" do
        put :update, params
      end

      it "assigns the comment as @comment" do
        put :update, params
        assigns[:comment].should equal(mock_comment)
      end

      it "re-renders the 'edit' template" do
        put :update, params
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    before do
      Comment.should_receive(:find).with("37").and_return(mock_comment(:destroy => true, :editable_by => false))
    end
    
    it "destroys the requested comment (if it's editable)" do
      mock_comment.should_receive(:editable_by).and_return(true)
      mock_comment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
    
    it "should not destroys the requested comment (if it's not editable)" do
      mock_comment.should_receive(:editable_by).and_return(false)
      mock_comment.should_not_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the comments list" do
      delete :destroy, :id => "37"
      response.should redirect_to(task_url(mock_comment.task, :anchor => "new_comment"))
    end
    
    it "returns ok when this is xhr request" do
      xhr :delete, :destroy, :id => "37"
      
      response.should be_success
      response.should_not redirect_to(task_url(mock_comment.task, :anchor => "new_comment"))
    end
  end

end
