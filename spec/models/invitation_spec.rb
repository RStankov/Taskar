require 'spec_helper'

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
end
