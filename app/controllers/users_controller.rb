class UsersController < ApplicationController
  layout "projects"
  
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :get_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to :users
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to :users
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user.destroy
    
    redirect_to :users
  end
  
  private
    def get_user
      @user = User.first(:conditions => {:id => params[:id]})
    end
end
