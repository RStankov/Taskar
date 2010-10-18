require 'spec_helper'

describe AccountUser do
  it { should belong_to(:user) }
  it { should belong_to(:account) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:account) }
  it { Factory(:account_user).should validate_uniqueness_of(:user_id).scoped_to(:account_id) }
end
