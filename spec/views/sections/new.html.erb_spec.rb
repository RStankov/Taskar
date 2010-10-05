require 'spec_helper'

describe "/sections/new.html.erb" do
  before(:each) do
    assign :project, @project = stub_model(Project)
    assign :section, Section.new(:project => @project)
  end

  it { render }
end
