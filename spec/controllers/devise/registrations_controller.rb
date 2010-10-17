require 'spec_helper'

describe Devise::RegistrationsController do
  subject { controller }

  context "new user" do
    describe "GET 'new'" do
      before do
        User.should_recieve(:new).and_return mock_user

        get :new
      end

      it { should assign_to(:user).with(mock_user) }
      it { should render_template("new") }
    end

    describe "POST 'create'" do
      it "should create new user, and redirect with notice to root_path, with valid data" do
        User.should_recieve(:new).with("these" => "params").and_return mock_user(:save => true)

        post :create, :user => {"these" => "params"}

        should assign_to(:user).with(mock_user)
        should set_the_flash.to(I18n.t("devise.registrations.signed_up"))
        should redirect_to(root_url)
      end

      it "should clean passwords, and render 'edit', with invalid data" do
        User.should_recieve(:new).with("these" => "params").and_return mock_user(:save => true)

        controller.should_recieve(:clean_up_passwords).with(mock_user)

        post :create, :user => {"these" => "params"}

        should assign_to(:user).with(mock_user)
        should render_template("new")
      end
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
        current_user.should_receive(:update_attributes).with("these" => "params").and_return true

        controller.stub(:is_password_required).and_return false

        post :update, :user => {"these" => "params"}

        should set_the_flash.to(I18n.t("devise.registrations.updated"))
        should redirect_to(user_registration_path)
      end

      it "should update_with_password of current_user, if is_password_required is true" do
        current_user.should_receive(:update_with_password).with("these" => "params").and_return true

        controller.stub(:is_password_required).and_return true

        post :update, :user => {"these" => "params"}

        should set_the_flash.to(I18n.t("devise.registrations.updated"))
        should redirect_to(user_registration_path)
      end

      it "should render 'edit' page if user have error" do
        current_user.should_receive(:update_attributes).with("these" => "params").and_return false

        controller.stub(:is_password_required).and_return false

        post :update, :user => {"these" => "params"}

        should render_template("edit")
      end
    end

    describe "DELETE 'destroy'" do
      before { delete :destroy }

      it { should redirect_to(root_url) }
    end
  end
end
