require 'spec_helper'

describe UsersController do
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  before do
    sign_in Factory(:user)
  end
  
  describe "index action" do
    before do
      User.should_receive(:all).and_return([mock_user])
      get :index
    end
    
    it "assigns all user as @users" do
      assigns[:users].should == [mock_user]
    end
    
    it "renders index template" do
      response.should render_template(:index)
    end
  end
  
  describe "show action" do
    before do
      User.should_receive(:first).with("15").and_return(mock_user)
      get :show, :id => "15"
    end
    
    it "assigns the requested user as @user" do
      assigns[:user].should equal(mock_user)
    end
    
    it "renders show template" do
      response.should render_template(:show)
    end
  end
  
  describe "new action" do
    before do
      get :new
    end
    
    it "assigns new user as @user" do
      assigns[:user].new_record?.should be_true
    end
    
    it "renders new template" do
      response.should render_template(:new)
    end
  end
  
  describe "create action" do
    def user_params
      {:these => "params"}
    end
    
    def post_create(params = {})
      post :create, {:user => user_params}.merge(params)
    end
    
    before do      
      User.should_receive(:new).with(user_params.stringify_keys).and_return(mock_user)
    end
    
    it "should render new template when user is invalid" do
      mock_user.should_receive(:save).and_return(false)
      
      post_create
      
      assigns[:user].should == mock_user
      response.should render_template(:new)
    end
    
    it "should redirect to users page, when user is valid" do
      mock_user.should_receive(:save).and_return(true)
      
      post_create
      
      response.should redirect_to(users_url)      
    end
  end
  
  describe "edit action" do
    before do
      User.should_receive(:first).with("15").and_return(mock_user)
      get :edit, :id => "15"
    end
  
    it "assigns the requested user as @user" do
      assigns[:user].should equal(mock_user)
    end
  
    it "renders edit template" do
      response.should render_template(:edit)
    end
  end
  
  describe "update action" do
    def user_params
      {:these => 'params'}
    end
    
    def put_update(params = {})
      put :update, {:id => 15, :user => user_params}.merge(params)
    end
    
    before do
      User.should_receive(:first).with("15").and_return(mock_user)
    end
  
    it "should render edit template when user is invalid" do
      mock_user.should_receive(:update_attributes).with(user_params.stringify_keys).and_return(false)
    
      put_update
    
      assigns[:user].should == mock_user
      response.should render_template(:edit)
    end
    
    it "should redirect to users page, when user is valid" do
      mock_user.should_receive(:update_attributes).with(user_params.stringify_keys).and_return(true)
    
      put_update
      
      response.should redirect_to(users_url)   
    end
  end
  
  describe "destroy action" do
    before do
      User.should_receive(:first).with("15").and_return(mock_user)
      mock_user.should_receive(:destroy)
    end
    
    it "destroys the requested user and redirects to users" do
      delete :destroy, :id => "15"
      response.should redirect_to(users_url)
    end
  end

end