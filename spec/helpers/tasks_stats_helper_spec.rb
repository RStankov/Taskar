require 'spec_helper'

describe TasksStatsHelper do
  describe "#tasks_stats_subject_name" do
    MAX_LENGTH = TasksStatsHelper::MAX_SUBJECT_LENGTH_NAME

    context "when subject.name is smaller then #{MAX_LENGTH} chars" do
      before { @subject = mock(Object, :name => "a" * MAX_LENGTH) }

      it "returns just <span>subject.name</span>" do
        helper.tasks_stats_subject_name(@subject).should == "<span>#{@subject.name}</span>"
      end
    end

    context "when subject.name is more than #{MAX_LENGTH} chars" do
      before { @subject = mock(Object, :name => "a" * MAX_LENGTH + "b") }

      it "uses truncate with :length => #{MAX_LENGTH}" do
        helper.should_receive(:truncate).with(@subject.name, :length => MAX_LENGTH)

        helper.tasks_stats_subject_name(@subject)
      end

      it "returns the <span>truncated subject name</span>" do
        truncated_text = helper.truncate(@subject.name, :length => MAX_LENGTH)
        helper.tasks_stats_subject_name(@subject).should have_selector("span", :content => truncated_text)
      end

      it "returns the span[title=subject.name]" do
        helper.tasks_stats_subject_name(@subject).should have_selector("span[title=\"#{@subject.name}\"]")
      end
    end
  end
end