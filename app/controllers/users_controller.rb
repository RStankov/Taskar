class UsersController < ApplicationController
  layout "admin"
  
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :check_for_admin
  before_filter :get_user, :only => [:show, :edit, :update, :destroy, :set_admin]
  
  def index
    @users = account.users
  end
  
  def show
  end
  
  def new
    @user = account.users.build
  end
  
  def create
    @user = account.users.build(params[:user])
    
    if @user.save
      redirect_to @user
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user.destroy
    
    redirect_to :users
  end
  
  def set_admin
    unless @user == current_user
      @user.admin = params[:admin]
      @user.save
    end
    
    redirect_to @user
  end
  
  private
    def get_user
      @user = account.users.find(params[:id])
    end
end
