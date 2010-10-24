require 'spec_helper'

describe Sign::RegistrationsController do
  subject { controller }

  context "new user" do
    before { controller.stub(:user_signed_in?).and_return false }

    describe "GET 'new'" do
      it "should render new form" do
        User.should_receive(:new).and_return mock_user

        get :new

        should assign_to(:user).with(mock_user)
        should render_template("new")
      end
    end

    describe "POST 'create'" do
      it "should create new user, and redirect with notice to root_path, with valid data" do
        User.should_receive(:new).with("these" => "params").and_return mock_user(:save => true)

        controller.should_receive(:sign_in).with(mock_user)

        post :create, :user => {"these" => "params"}

        should assign_to(:user).with(mock_user)
        should set_the_flash.to(I18n.t("devise.registrations.signed_up"))
        should redirect_to(root_url)
      end

      it "should clean passwords, and render 'edit', with invalid data" do
        User.should_receive(:new).with("these" => "params").and_return mock_user(:save => false)

        mock_user.should_receive(:clean_up_passwords)

        post :create, :user => {"these" => "params"}

        should assign_to(:user).with(mock_user)
        should render_template("new")
      end
    end
  end

 {
    :new       => 'get(:new)',
    :create    => 'post(:create)'
  }.each do |(action, code)|
    it "should redirect the logged user to root_path when try to access #{action}" do
      sign_in Factory(:user)

      eval code

      should redirect_to(:root)
    end
  end

  context "existing user" do
    before do
      sign_in @current_user = Factory(:user)

      controller.stub(:current_user).and_return @current_user
    end

    describe "GET 'edit'" do
      before { get :edit }

      it { should render_template("edit") }
    end

    describe "PUT 'update'" do
      it "should update_attributes of current_user, if is_password_required is false" do
        @current_user.should_receive(:update_attributes).with("these" => "params").and_return true

        controller.stub(:is_password_required).and_return false

        post :update, :user => {"these" => "params"}

        should set_the_flash.to(I18n.t("devise.registrations.updated"))
        should redirect_to(edit_user_registration_url)
      end

      it "should update_with_password of current_user, if is_password_required is true" do
        @current_user.should_receive(:update_with_password).with("these" => "params").and_return true

        controller.stub(:is_password_required).and_return true

        post :update, :user => {"these" => "params"}

        should set_the_flash.to(I18n.t("devise.registrations.updated"))
        should redirect_to(edit_user_registration_url)
      end

      it "should render 'edit' page if user have error" do
        @current_user.should_receive(:update_attributes).with("these" => "params").and_return false

        controller.stub(:is_password_required).and_return false

        @current_user.should_receive(:clean_up_passwords)

        post :update, :user => {"these" => "params"}

        should render_template("edit")
      end
    end

    describe "DELETE 'destroy'" do
      before { delete :destroy }

      it { should redirect_to(root_url) }
    end
  end

  describe "#is_password_required" do
    def set_params(params)
      controller.stub(:params).and_return params
    end

    def is_password_required
      controller.__send__(:is_password_required)
    end

    it "should be false params[:user] is not set" do
      is_password_required.should be_false
    end

    it "should be true if params[:user][:password] is presented" do
      set_params :user => {:password => "1"}

      is_password_required.should be_true
    end

    it "should be true if params[:user][:password_confirmation] is presented" do
      set_params :user => {:password_confirmation => "1"}

      is_password_required.should be_true
    end

    it "should be true if params[:email] is different from current users email" do
      set_params :user => {:email => "foo@bar.com"}

      controller.stub(:current_user).and_return mock_user(:email => "some@other.email")

      is_password_required.should be_true
    end

    it "should be false if params[:user] is presented, but :password, :password_confirmation are not" do
      set_params :user => {:fist_name => "foo"}

      is_password_required.should be_false

      set_params :user => {:email => "user@mail.com"}

      controller.stub(:current_user).and_return mock_user(:email => "user@mail.com")

      is_password_required.should be_false
    end
  end
end
