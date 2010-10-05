require 'spec_helper'

describe Account do
    it_should_allow_mass_assignment_only_of :name

    it { should belong_to(:owner) }
    it { should validate_presence_of(:name) }
    it { Factory(:account).should validate_uniqueness_of(:name) }

    it { should have_many(:users) }
    it { should have_many(:projects) }

    describe "find_id_by_name" do
      it "should find account id for given name" do
        account = Factory(:account)
        Account.find_id_by_name(account.name).should == account.id
      end

      it "should return nil if name is nil" do
        Account.find_id_by_name(nil).should be_nil
      end

      it "should return nil if account doesn't exists" do
        Account.find_id_by_name("not - existing - name").should be_nil
      end
    end
end
