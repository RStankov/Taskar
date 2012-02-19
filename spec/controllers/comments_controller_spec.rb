require 'spec_helper'

describe CommentsController do
  let(:comment) { double :id => '1', :task => mock_task, :user => mock_user, :project => mock_project }

  subject { controller }

  describe "with project user" do
    before { sign_with_project_user }

    def controller_should_fire_event
      controller.should_receive(:activity).with(comment)
    end

    def comment_url
      task_url(comment.task, :anchor => "comment_#{comment.id}")
    end

    context "member action" do
      before do
        Comment.should_receive(:find).with("1").and_return comment
        comment.stub(:editable_by?).and_return true
      end

      describe "GET show" do
        context "" do
          before { get :show, :id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should redirect_to(comment_url) }
        end

        context "xhr" do
          before { xhr :get, :show, :id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should render_template('show') }
        end
      end

      describe "GET edit" do
        context "" do
          before { get :edit, :id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should redirect_to(task_url(comment.task, :anchor => "comment_#{comment.id}")) }
        end

        context "xhr" do
          before { xhr :get, :edit, :id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should render_template("edit") }
        end
      end

      describe "PUT update" do
        def params
          {:id => "1", :comment => {:these => 'params'}}
        end

        context "with valid params" do
          before do
            comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)

            controller_should_fire_event
          end

          context "" do
            before { put :update, params }

            it { should assign_to(:comment).with(comment) }
            it { should redirect_to(comment_url) }
          end

          context "xhr" do
            before { xhr :put, :update, params }

            it { should assign_to(:comment).with(comment) }
            it { should render_template("show") }
          end
        end

        context "with invalid params" do
          before do
            comment.should_receive(:update_attributes).with({'these' => 'params'}).and_return(false)
          end

          context "" do
            before { put :update, params }

            it { should assign_to(:comment).with(comment) }
            it { should redirect_to(comment_url) }
          end

          context "xhr" do
            before { xhr :put, :update, params }

            it { should assign_to(:comment).with(comment) }
            it { should render_template("edit") }
          end
        end

      end

      describe "DELETE destroy" do
        before do
          comment.should_receive(:destroy)

          controller_should_fire_event
        end

        it "redirects after destroy on normal request" do
          delete :destroy, :id => "1"
          should redirect_to(task_url(comment.task))
        end

        it "it render tempalte on xhr request " do
          xhr :delete, :destroy, :id => "1"
          should render_template("destroy")
        end
      end

    end

    describe "POST create" do
      before do
        Task.should_receive(:find).with("1").and_return mock_task

        controller.current_user.should_receive(:new_comment).with(mock_task, {"these" => "params"}).and_return comment
      end

      context "with valid params" do
        before do
          comment.stub(:save).and_return true

          controller_should_fire_event
        end

        context "" do
          before { post :create, :comment => {:these => 'params'}, :task_id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should redirect_to(comment_url) }
        end

        context "xhr" do
          before { xhr :post, :create, :comment => {:these => 'params'}, :task_id => "1" }


          it { should assign_to(:comment).with(comment) }
          it { should render_template("show") }
        end
      end

      context "with invalid params" do
        before { comment.stub(:save).and_return false }

        context "" do
          before { post :create, :comment => {:these => 'params'}, :task_id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should redirect_to(comment_url) }
        end

        context "xhr" do
          before { xhr :post, :create, :comment => {:these => 'params'}, :task_id => "1" }

          it { should assign_to(:comment).with(comment) }
          it { should render_template("new") }
        end
      end

    end

    describe "get_comment_and_ensure_its_editable filter (with not editable comment)" do
      before do
        Comment.should_receive(:find).with("1").and_return(comment)
        comment.stub!(:editable_by?).and_return(false)
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
          redirect_to(task_url(comment.task, :anchor => "comment_#{comment.id}"))
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
        Comment.should_receive(:find).with("1").and_return(comment)

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
