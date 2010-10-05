require 'spec_helper'

describe Issue do
  it_should_allow_mass_assignment_only_of :url, :description

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:description) }
end
