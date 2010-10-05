require 'spec_helper'

describe Account do
    it_should_allow_mass_assignment_only_of :name, :domain

    it { should belong_to(:owner) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:domain) }
    it { Factory(:account).should validate_uniqueness_of(:name) }
    it { Factory(:account).should validate_uniqueness_of(:domain) }

    it { should_not allow_value('domain.com').for(:domain) }
    it { should_not allow_value('лоши_синволи').for(:domain) }
    it { should allow_value('valid address').for(:domain) }
    it { should allow_value('next').for(:domain) }
    it { should allow_value('pixel_depo').for(:domain) }
    it { should allow_value('1301').for(:domain) }

    it { should have_many(:users) }
    it { should have_many(:projects) }

    it "should normalize the domain name" do
      account = Factory(:account, :domain => "Title Cased")
      account.should_not be_new_record
      account.domain.should == "title_cased"
    end

    describe "#find_id_by_domain" do
      it "should find account id for given domain" do
        account = Factory(:account)
        Account.find_id_by_domain(account.domain).should == account.id
      end

      it "should be case insensitive" do
        account = Factory(:account)
        Account.find_id_by_domain(account.domain.upcase).should == account.id
      end

      it "should return nil if domain is nil" do
        Account.find_id_by_domain(nil).should be_nil
      end

      it "should return nil if account doesn't exists" do
        Account.find_id_by_domain("not - existing - name").should be_nil
      end
    end
end
