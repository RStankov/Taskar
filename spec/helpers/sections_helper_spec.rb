require 'spec_helper'

describe SectionsHelper do
  describe "#new_section_link" do

    before do
      assign :project, @project = mock_project

      helper.stub(:t).and_return ""
      helper.stub(:insert_at).and_return ""
    end

    it "return a.add_section" do
      helper.new_section_link.should have_selector("a.add_section")
    end

    it "return a.add_section[data-before=] if before argument is given" do
      helper.new_section_link(mock_section).should have_selector("a.add_section[data-before=\"#{mock_section.id}\"]")
    end

    it "returns a tag with href new_project_section" do
      href = new_project_section_path(@project)

      helper.new_section_link.should have_selector("a[href=\"#{href}\"]")
    end
  end

  def mock_participant_with_status(status, last_active_at = Time.now)
    @participant ||= stub :status => status, :user => stub(:last_active_at => last_active_at)
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

      returned.should include(status)
      returned.should include(helper.participant_last_action(participant))
    end
  end

  describe "#participant_status" do
    it "returns #participant_last_action if participant don't have status" do
      perticipant = mock_participant_with_status ""
      helper.participant_status(perticipant).should == helper.participant_last_action(perticipant)
    end

    it "returns formated participent status" do
      status = "1\n2\n3\n4\n5\n6"
      helper.participant_status(mock_participant_with_status status).should == helper.simple_format(status)
    end
  end

  describe "#participant_last_action" do
    it "should return empty string if no action was preformed" do
      helper.participant_last_action(mock_participant_with_status("foo", nil)).should == ""
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

    describe "#section_is_tasks?" do
      before { assign :section, mock_section }

      after { assign :section,  nil }

      it "returns true if section is assigned and it is not archived" do
        mock_section.stub(:archived?).and_return false

        helper.section_is_tasks?.should be_true
      end

      it "returns false if section is assigned but is archived" do
        mock_section.stub(:archived?).and_return true

        helper.section_is_tasks?.should be_false
      end

      it "returns false if section is not assigned" do
        assign :section, nil

        helper.section_is_tasks?.should be_false
      end
    end

    describe "#section_is_archive?" do
      before { assign :section, mock_section }

      after { assign :section, nil }

      it "returns false if section is assigned and it is not archived" do
        mock_section.stub(:archived?).and_return false

        helper.section_is_archive?.should be_false
      end

      it "returns true if section is assigned but is archived" do
        mock_section.stub(:archived?).and_return true

        helper.section_is_archive?.should be_true
      end

      it "returns false if section is not assigned" do
        assign :section, nil

        helper.section_is_archive?.should be_false
      end

      it "returns true on sections#archived" do
        assign :section, nil

        controller_and_action "sections", "archived"

        helper.section_is_archive?.should be_true
      end
    end
  end
end
