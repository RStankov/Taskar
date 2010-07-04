require 'spec_helper'

describe ApplicationHelper do
  describe "copywrite" do
    it "returns the t(:copywrite) with the current year" do
      helper.copywrite.should == t(:'copywrite', :year => Time.now.year)
    end
  end
  
  describe "time_tag" do
    it "returns html5 time tag datetime/title attributes" do
      time     = Time.now
      text     = t(:before, :time => helper.time_ago_in_words(time))
      expected = '<time datetime="' + time.rfc2822  + '" title="' + l(time, :format => :long) + '">' + text + '</time>'
      
      helper.time_tag(time).should == expected
    end
  end
  
  describe "csrf_meta_tag" do
    before do
      helper.stub!(:protect_against_forgery?).and_return(true)
      helper.stub!(:request_forgery_protection_token).and_return("foo")
      helper.stub!(:form_authenticity_token).and_return("bar")
    end
    
    it "should be nil if we are not protecting from forgery" do
      helper.should_receive(:protect_against_forgery?).and_return(false)
      helper.csrf_meta_tag.should == nil
    end
    
    it "should contain meta[name=csrf-param]" do
      helper.csrf_meta_tag.should have_tag("meta[name=csrf-param][content=foo]")
    end
    
    it "should contain meta[name=csrf-token]" do
      helper.csrf_meta_tag.should have_tag("meta[name=csrf-token][content=bar]")
    end    
  end
end
