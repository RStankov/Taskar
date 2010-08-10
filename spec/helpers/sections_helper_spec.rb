require 'spec_helper'

describe SectionsHelper do
  describe "#new_section_link" do
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

  describe "#participant_status_title" do
    def mock_participant_with_status(status)
      @participant ||= stub :status => status, :user => stub(:last_active_at => Time.now)
    end
    
    it "returns nil if participant don't have status" do
      helper.participant_status_title(mock_participant_with_status(nil)).should be_nil
    end
    
    it "returns #participant_last_action if status is less than 100 chars" do
      participant = mock_participant_with_status "123456"
      helper.participant_status_title(participant).should == helper.participant_last_action(participant)
    end
    
    it "returns participant.status + #participant_last_action" do
      status      = "1" * 100 + "0"
      participant = mock_participant_with_status status
      returned    = helper.participant_status_title(participant)
      
      returned.should include_text(status)
      returned.should include_text(helper.participant_last_action(participant))
    end
  end
end
