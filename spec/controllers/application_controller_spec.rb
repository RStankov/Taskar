require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  subject { controller }

  describe "#deny_access" do
    it "should redirect_to root_path" do
      controller.stub(:request).and_return(mock(Object, :xhr? => false))
      controller.stub(:root_path).and_return("root_path")
      controller.should_receive(:redirect_to).with("root_path", :alert => I18n.t(:deny_access))

      controller.send(:deny_access)
    end

    it "should head forbidden on xhr request" do
      controller.stub(:request).and_return(mock(Object, :xhr? => true))
      controller.should_receive(:head).with(:forbidden)

      controller.send(:deny_access)
    end
  end

  describe "#event" do
    it "should create user activity" do
      user = Factory(:user)
      task = Factory(:task)

      controller.should_receive(:current_user).and_return(user)
      controller.send(:activity, task)

      task.event.user.should == user
    end
  end

  it "have rescue_from who will render 404 page and set 404 status" do
    controller.should_receive(:render).with(:action => "shared/not_found", :layout => "application", :status => 404);
    controller.send(:record_not_found)
  end

  describe "#project_user" do
    it "should get ProjectUser related to current_user and project, and should cache the result" do
      controller.should_receive(:current_user).and_return mock_user(:id => 1)
      controller.instance_variable_set "@project", mock_project(:id => 2)

      ProjectUser.should_receive(:find_by_user_id_and_project_id).with(1, 2).and_return mock_project_user

      controller.send(:project_user).should == mock_project_user
    end
  end

  describe "#set_locale" do
    it "should not try to set locale if current_user is nil" do
      I18n.should_not_receive(:locale=)

      controller.stub(:user_signed_in?).and_return false
      controller.__send__(:set_locale)
    end

    it "should not try to set locale if current_user.locale is not in I18n.available_locales" do
      I18n.should_not_receive(:locale=)

      controller.stub(:user_signed_in?).and_return true
      controller.stub(:current_user).and_return mock_user(:locale => "#{I18n.available_locales.first}_not_existing")
      controller.__send__(:set_locale)
    end

    it "should try to set locale to current_user.locale if it exists and it in I18n.available_locales" do
      locale = I18n.available_locales.last.to_s

      I18n.should_receive(:locale=).with(locale.to_sym)

      controller.stub(:user_signed_in?).and_return true
      controller.stub(:current_user).and_return mock_user(:locale => locale)
      controller.__send__(:set_locale)
    end
  end
end