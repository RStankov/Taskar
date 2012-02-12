require 'spec_helper'

describe InvitationsMailer do
  describe "invite" do
    let(:invite) { mock_model Invitation, :account_name => 'Apple', :email => 'rs@example.org', :full_name => 'Radoslav Stankov', :token => 'foo' }

    subject { InvitationsMailer.invite(invite) }

    it { should have_subject 'Apple is inviting you to join their team at Taskar' }
    it { should deliver_to 'rs@example.org' }
    it { should have_body_text /Accept invitation/ }
  end
end
