require 'spec_helper'

describe SectionsHelper do
  describe "new_section_link" do
    before do
      assigns[:project] = @project = mock_project
      
      helper.stub(:t).and_return("")
    end
    
    it "return li.add_section" do
      helper.new_section_link.should have_tag("li.add_section")
    end
    
    it "return li.add_section[data-before=] if before argument is given" do
      helper.new_section_link(mock_section).should have_tag("li.add_section[data-before=#{mock_section.id}]")
    end
    
    it "returns li tag with a to new_project_section" do
      href = new_project_section_path(@project)
      
      helper.new_section_link.should have_tag("li.add_section > a[href=#{href}]")
    end
    
    it "returns li tag with a to new_project_section + before if before argument is given" do
      href = new_project_section_path(@project, :before => mock_section.id)
      
      helper.new_section_link(mock_section).should have_tag("li.add_section > a[href=#{href}]")
    end
  end

end
