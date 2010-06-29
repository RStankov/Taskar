require 'spec_helper'

describe CommentsController do
  describe "with project user" do
    before { sign_with_project_user }
    
    def should_fire_event(action)
      controller.should_receive(:activity).with(action, mock_comment)
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
        
        controller.current_user.should_receive(:new_comment).with(mock_task, {"these" => "params"}).and_return(mock_comment)
      end

      describe "with valid params" do
        before do
          mock_comment.stub!(:save).and_return(true)

          should_fire_event(:commented)

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

    describe "GET edit" do 
      before do
        Comment.should_receive(:find).with("1").and_return(mock_comment)
        mock_comment.stub!(:editable_by?).and_return(true)

        get :edit, :id => "1"
      end

      it "assigns comment as @comment" do
        assigns[:comment].should == mock_comment
      end

      it "renders edit template" do
        response.should render_template(:edit)
      end
    end

    describe "PUT update" do
      before do
        Comment.should_receive(:find).with("1").and_return(mock_comment)
        mock_comment.stub!(:editable_by?).and_return(true)
      end

      def params
        {:id => "1", :comment => {:these => 'params'}}
      end

      describe "with valid params" do
        before do
          mock_comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
          
          should_fire_event(:commented)
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
        Comment.should_receive(:find).with("37").and_return(mock_comment(:destroy => true, :editable_by? => false))
        mock_comment.stub!(:editable_by?).and_return(true)
        
        should_fire_event(:deleted)
      end

      it "destroys the requested comment (if it's editable)" do
        mock_comment.should_receive(:editable_by?).and_return(true)
        mock_comment.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the comments list" do
        delete :destroy, :id => "37"
        response.should redirect_to(task_url(mock_comment.task))
      end

      it "returns ok when this is xhr request" do
        xhr :delete, :destroy, :id => "37"

        response.should be_success
        response.should_not redirect_to(task_url(mock_comment.task))
      end
    end

    describe "get_comment_and_ensure_its_editable filter (with not editable comment)" do
      before do
        Comment.should_receive(:find).with("1").and_return(mock_comment)
        mock_comment.stub!(:editable_by?).and_return(false)
      end


      describe "sets status to :bad_request, on xhr" do
        it "on GET edit" do
          xhr :get, :edit, :id => "1"

          response.should_not be_success
        end

        it "on PUT update" do
          xhr :put, :update, :id => "1"

          response.should_not be_success
        end

        it "on DELETE destroy" do
          xhr :delete, :destroy, :id => "1"

          response.should_not be_success
        end
      end

      describe "redirect" do
        def redirect_to_comment
          redirect_to(task_url(mock_comment.task, :anchor => "comment_#{mock_comment.id}"))
        end

        it "on GET edit" do
          get :edit, :id => "1"

          response.should redirect_to_comment
        end

        it "on PUT update" do
          put :update, :id => "1"

          response.should redirect_to_comment
        end

        it "on DELETE destroy" do
          delete :destroy, :id => "1"

          response.should redirect_to_comment
        end
      end

    end

  end
  
  describe "with user outside project" do
    before { sign_with_user_outside_the_project }
    
    {
      :show       => 'get(:show, :id => "1")',
      :edit       => 'get(:edit, :id => "1")',
      :update     => 'put(:update, :id => "1")',
      :destroy    => 'delete(:destroy, :id => "1")',
    }.each do |(action, code)|
      it "should not allow #{action}, and redirect_to root_url" do
        Comment.should_receive(:find).with("1").and_return(mock_comment)
        
        eval code
      end
    end
    
    {
      :create     => 'post(:create, :task_id => "1")',
    }.each do |(action, code)|
     it "should not allow #{action}, and redirect_to root_url" do
       Task.should_receive(:find).with("1").and_return(mock_task)
      
       eval code
     end
    end
  end
end
