require 'spec_helper'

describe ApplicationHelper do
  describe "copywrite" do
    it "returns the t(:copywrite) with the current year" do
      helper.copywrite.should == t(:'copywrite', :year => Time.now.year)
    end
  end
  
  describe "time_tag" do
    it "returns html5 time tag datetime/title attributes" do
      time = Time.now
      expected = '<time datetime="' + time.rfc2822  + '" title="' + l(time, :format => :long) + '">' + helper.time_ago_in_words(time) + '</time>'
      
      helper.time_tag(time).should == expected
    end
  end
end
