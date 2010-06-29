require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  describe "deny_access" do
    it "should redirect_to root_path" do
      controller.stub!(:request).and_return(mock(Object, :xhr? => false))
      controller.stub!(:root_path).and_return("root_path")
      controller.should_receive(:redirect_to).with("root_path")
      
      controller.send(:deny_access)
    end
    
    it "should head forbidden on xhr request" do
      controller.stub!(:request).and_return(mock(Object, :xhr? => true))
      controller.should_receive(:head).with(:forbidden)
      
      controller.send(:deny_access)
    end
  end
  
  describe "event" do
    it "should call Event.activity with action and subject" do
      Event.should_receive(:activity).with(mock_user, :created, mock_comment)
      controller.should_receive(:current_user).and_return(mock_user)
      
      controller.send(:event, :created, mock_comment)
    end
  end
end