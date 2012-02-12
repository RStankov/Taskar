require 'spec_helper'

describe AccountMember do
  it "delegates to user" do
    user = double :full_name => 'Radoslav Stankov', :email => 'rs@example.com', :avatar => 'avatar'
    member = AccountMember.new(user, double)

    member.full_name.should eq user.full_name
    member.email.should eq user.email
    member.avatar.should eq user.avatar
    member.to_model.should eq user
  end

  describe "find" do
    let(:user)    { create :user }
    let(:account) { create :account }

    it "finds an account member by account and user id" do
      create :account_user, :account =>  account, :user => user

      member = AccountMember.find(account, user.id)
      member.user.should eq user
      member.account.should eq account
    end

    it "raises record not found if user doesn't exists in this account" do
      expect { AccountMember.find(account, user.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  it "can tell if an user is account owner" do
    user    = double :id => 1
    account = double :owner_id => 1

    AccountMember.new(user, account).should be_owner
  end

  describe "admin?" do
    let(:user)    { create :user }
    let(:account) { create :account }

    it "returns true if users is account owner" do
      user    = double :id => 1
      account = double :owner_id => 1

      AccountMember.new(user, account).should be_admin
    end

    it "returns true if account user connecting the user and the account is admin" do
      create :account_user, :account =>  account, :user => user, :admin => true

      AccountMember.new(user, account).should be_admin
    end

    it "returns false if account user connecting the user and the account is admin" do
      create :account_user, :account =>  account, :user => user, :admin => true

      AccountMember.new(user, account).should be_admin
    end
  end
end
