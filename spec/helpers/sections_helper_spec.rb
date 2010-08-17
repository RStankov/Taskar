require 'spec_helper'

describe SectionsHelper do
  describe "#new_section_link" do
    
    before do
      assigns[:project] = @project = mock_project
      
      helper.stub(:t).and_return ""
      helper.stub(:tooltip).and_return ""
    end
    
    it "return a.add_section" do
      helper.new_section_link.should have_tag("a.add_section")
    end
    
    it "return a.add_section[data-before=] if before argument is given" do
      helper.new_section_link(mock_section).should have_tag("a.add_section[data-before=#{mock_section.id}]")
    end
    
    it "returns a tag with href new_project_section" do
      href = new_project_section_path(@project)
      
      helper.new_section_link.should have_tag("a[href=#{href}]")
    end
  end

  def mock_participant_with_status(status)
    @participant ||= stub :status => status, :user => stub(:last_active_at => Time.now)
  end
  
  describe "#participant_status_title" do
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
  
  describe "#participant_status_title" do
    it "returns #participant_last_action if participant don't have status" do
      perticipant = mock_participant_with_status ""
      helper.participant_status(perticipant).should == helper.participant_last_action(perticipant)
    end
    
    it "returns formated participent status" do
      status = "1\n2\n3\n4\n5\n6"
      helper.participant_status(mock_participant_with_status status).should == helper.simple_format(status)
    end
  end

  context "section checker" do
    def controller_and_action(controller_name, action_name)
      helper.stub(:controller_name).and_return controller_name
      helper.stub(:action_name).and_return action_name
    end
    
    describe "#section_is_dashboard?" do
      it "returns true on sections#index" do
        controller_and_action "sections", "index"
        
        helper.section_is_dashboard?.should be_true
      end

      it "returns true on statuses#index" do
        controller_and_action "statuses", "index"
        
        helper.section_is_dashboard?.should be_true
      end
    end
    
  end
end
