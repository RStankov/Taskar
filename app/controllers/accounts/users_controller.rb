class Accounts::UsersController < Accounts::BaseController
  before_filter :get_user, :only => [:show, :edit, :update, :destroy, :set_admin]

  def index
    @users = @account.users
  end

  def show
  end

  def new
    @user = @account.users.build
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      AccountUser.create(:user => @user, :account => @account)

      redirect_to [@account, @user]
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to [@account, @user]
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy

    redirect_to [@account, :users]
  end

  def set_admin
    unless @user == current_user
      @account.set_admin_status(@user, params[:admin])
    end

    redirect_to [@account, @user]
  end

  private
    def get_user
      @user = @account.users.find(params[:id])
    end
end
