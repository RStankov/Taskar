require 'spec_helper'

describe Sign::InvitationsController do
  let(:invitation) { mock_model(Invitation, :user => user) }
  let(:user)       { mock_model(User) }

  describe "GET 'show'" do
    it "shows invitation by token" do
      Invitation.should_receive(:find_by_token).with('token_value').and_return invitation

      get :show, :id => 'token_value'

      controller.should assign_to(:invitation).with(invitation)
      controller.should render_template 'show'
    end

    it "renders invalid token page if invitation doesn't exists" do
      Invitation.should_receive(:find_by_token).with('token_value').and_return nil

      get :show, :id => 'token_value'

      controller.should render_template 'not_found'
    end
  end

  describe "PUT 'update'" do
    before do
      Invitation.stub(:find_by_token).with('token_value').and_return invitation
      controller.stub :sign_in
    end

    it "accepts the invitation" do
      invitation.should_receive(:accept).with('these' => 'params').and_return true

      put :update, :id => 'token_value', :user => {'these' => 'params'}
    end

    it "signs in invitation's user if invitations is accepted" do
      invitation.stub :accept => true
      controller.should_receive(:sign_in).with(user)

      put :update, :id => 'token_value'
    end

    it "redirecs to root page with flash message if invitation is accepted" do
      invitation.stub :accept => true

      put :update, :id => 'token_value'

      controller.should set_the_flash
      controller.should redirect_to(:root)
    end

    it "renders show page if invitation is not accepted" do
      invitation.stub :accept => false

      put :update, :id => 'token_value'

      controller.should assign_to(:invitation).with(invitation)
      controller.should render_template('show')
    end
  end
end
