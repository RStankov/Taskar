require 'spec_helper'

describe Sign::InvitationsController do

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => "aaa"
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "should be successful" do
      get 'update', :id => "aaa"
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get 'destroy', :id => "aaa"
      response.should be_success
    end
  end

end
