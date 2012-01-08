class InvitationsMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation

    mail :to => @invitation.email, :subject => "#{invitation.account_name} is inviting you to join their team at Taskar"
  end
end