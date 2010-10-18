require 'spec_helper'
require 'digest/sha1'

describe Invitation do
  it_should_allow_mass_assignment_only_of :email, :first_name, :last_name, :message

  it { should belong_to(:account) }
  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { Factory(:invitation).should validate_uniqueness_of(:email).scoped_to(:account_id) }
  it { should_not allow_value('not valid address').for(:email) }
  it { should_not allow_value('domain.com').for(:email) }
  it { should_not allow_value('some@domain').for(:email) }
  it { should allow_value('some@domain.com').for(:email) }

  describe "#generate_token" do
    it "should be genereated of sha1 of [invitation-token-{Time.now}-{email}-{rand(100)}]" do
      invate = Factory.build(:invitation)
      invate.stub(:rand).with(100).and_return 5
      invate.save.should be_true
      invate.should_not be_new_record
      invate.token.should == Digest::SHA1.hexdigest("[invitation-token-#{Time.now}-#{invate.email}-5]")
    end
  end
end
