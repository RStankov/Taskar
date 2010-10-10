require 'spec_helper'

describe ApplicationHelper do
  describe "#link_to_delete" do
    it "should add data-method=delete" do
      helper.link_to_delete('foo', 'bar').should have_selector('a[data-method=delete][href=bar]', :content => 'foo')
    end

    it "should replace confirm with data-confirm" do
      helper.link_to_delete('foo', 'bar', :confirm => 'blaaaa').should have_selector('a[data-confirm=blaaaa]')
    end
  end

  describe "#title" do
    before do
      helper.stub(:t).with("foo", :default => "foo").and_return "bar"

      helper.content_for(:title) { "" }
    end

    it "should pass title to 't' helper" do
      helper.should_receive(:t).with("foo", :default => "foo").and_return "bar"

      helper.title("foo")
    end

    it "should save t(title) to @content_for_title variable" do
      helper.title("foo")

      helper.content_for(:title).should == "bar"
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

  describe "#insert_at" do
    it "contains .insert_at" do
      helper.insert_at("foo").should have_selector(".insert_at")
    end

    it "contains .insert_at .pointer" do
      helper.insert_at("foo").should have_selector(".insert_at .pointer")
    end

    it "contains the given text" do
      helper.insert_at("given text").should have_selector(".insert_at", :content => "given text")
    end
  end

  describe "#nl2br" do
    it "should replace the new lines with <br>" do
      helper.nl2br("line 1\nline 2\nline 3").should == "line 1<br />line 2<br />line 3"
    end

    it "should escape the given input" do
      helper.nl2br("<div>\n<img>").should == "&lt;div&gt;<br />&lt;img&gt;"
    end

    it "should catch \\r\\n" do
      helper.nl2br("line 1\r\nline 2").should == "line 1<br />line 2"
    end

    it "should allow several empty lines" do
      helper.nl2br("line 1\n\nline 2\n\nline 3").should == "line 1<br /><br />line 2<br /><br />line 3"
    end

    it "should be html_safe?" do
      helper.nl2br("text").should be_html_safe
    end
  end
end
