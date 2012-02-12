require 'spec_helper'

describe Account do
  it_should_allow_mass_assignment_only_of :name

  it { should belong_to(:owner) }
  it { should validate_presence_of(:name) }
  it { create(:account).should validate_uniqueness_of(:name) }

  it { should have_many(:account_users) }
  it { should have_many(:users) }
  it { should have_many(:projects) }
  it { should have_many(:invitations) }
end
