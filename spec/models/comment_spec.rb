require 'spec_helper'

describe Comment do
  it_should_allow_mass_assignment_only_of :text

  it { should belong_to(:user) }
  it { should belong_to(:task) }
  it { should belong_to(:project) }
  it { should have_one(:event) }

  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:task) }
  it { should validate_presence_of(:project) }

  it_should_have_counter_cache_of :task
  it_should_have_counter_cache_of :user

  let(:comment) { Factory(:comment) }
  let(:user) { Factory(:user) }

  it "inherits the project_id from its parent task" do
    task = Factory(:task)

    comment = user.new_comment(task, :text => "text")

    comment.save.should be_true
    comment.project_id.should == comment.project_id
  end

  it "can't be added to archived task" do
    task    = Factory(:task, :status => 1, :archived => true)
    comment = Factory.build(:comment, :task => task)

    comment.save.should be_false
    comment.errors[:base].should == [I18n.t('activerecord.errors.comments.archived_task')]
  end

  describe "#editable_by?" do
    it "returns false for user who is not comment creator" do
      comment.should_not be_editable_by(user)
    end

    it "returns true for the current user (if updated_at in Comment::EDITABLE_BY time)" do
      comment.updated_at = Time.now
      comment.should be_editable_by(comment.user)
    end

    it "returns false for the current user (if updated_at out of Comment::EDITABLE_BY time)" do
      comment.updated_at = Time.now - 2 * Comment::EDITABLE_BY
      comment.should_not be_editable_by(comment.user)
    end
  end

  describe "#editable_for" do
    it "returns diffrence between Comment::EDITABLE_BY and updated_at " do
      comment.editable_for.should == (((comment.updated_at + Comment::EDITABLE_BY) - Time.now) / 60).ceil
    end

    it "returns 0 if this is not editable" do
      comment.updated_at = Time.now - 2 * Comment::EDITABLE_BY
      comment.editable_for.should == 0
    end
  end
end
