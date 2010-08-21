require 'spec_helper'

describe ApplicationHelper do
  describe "#link_to_delete" do
    it "should add data-method=delete" do
      helper.link_to_delete('foo', 'bar').should have_tag('a[data-method=delete][href=bar]', 'foo')
    end
    
    it "should replace confirm with data-confirm" do
      helper.link_to_delete('foo', 'bar', :confirm => 'blaaaa').should have_tag('a[data-confirm=blaaaa]')
    end  
  end
  
  describe "#title" do
    before do
      helper.stub(:t).with("foo", :default => "foo").and_return "bar"
      assigns[:content_for_title] = nil
    end
    
    it "should pass title to 't' helper" do
      helper.should_receive(:t).with("foo", :default => "foo").and_return "bar"
      
      helper.title("foo")
    end
    
    it "should save t(title) to @content_for_title variable" do
      helper.title("foo")
      
      assigns[:content_for_title].should == "bar"
    end
    
    it "should return t(title) wrapped in h1" do
      helper.title("foo").should == "<h1>bar</h1>"
    end
  end
  
  describe "#copywrite" do
    it "returns the t(:copywrite) with the current year" do
      helper.copywrite.should == t(:'copywrite', :year => Time.now.year)
    end
  end
  
  describe "#time_tag" do
    it "returns html5 time tag datetime/title attributes" do
      time     = Time.now
      text     = t(:before, :time => helper.time_ago_in_words(time))
      expected = '<time datetime="' + time.rfc2822  + '" title="' + l(time, :format => :long) + '">' + text + '</time>'
      
      helper.time_tag(time).should == expected
    end
  end
  
  describe "#csrf_meta_tag" do
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

  describe "#tooltip" do
    it "contains .tooltip" do
      helper.tooltip("foo").should have_tag(".tooltip")
    end
    
    it "contains .tooltip .arrow" do
      helper.tooltip("foo").should have_tag(".tooltip .arrow")
    end
    
    it "contains .tooltip .actions" do
      helper.tooltip("foo").should have_tag(".tooltip .actions")
    end
    
    it "contains the given text" do
      helper.tooltip("given text").should have_tag(".tooltip .actions", :text => "given text")
    end
  
    it "accepts block and captures it" do
      helper.tooltip { "text from the block"}.should have_tag(".tooltip .actions", :text => "text from the block")
    end
  
    it "accepts hash of attributes as secord argument" do
      helper.tooltip("given text", :style => "display:none").should have_tag(".tooltip[style=display:none]", :text => "given text")
    end 
  end
end
