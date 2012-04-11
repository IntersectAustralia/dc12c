# coding: utf-8
require 'spec_helper'

def assert_localdate_equal(utc_time, ymd)
  local = utc_time.localtime
  [local.year, local.month, local.day].should eq ymd
end

describe AccessRequest do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :papyrus }
  end
  describe "approve!" do
    before :each do
      now = Time.new(2012, 4, 3)
      Time.stub!(:now).and_return(now)
    end
    it "sets the status to APPROVED" do
      a = Factory(:access_request, status: AccessRequest::CREATED)
      a.approve!
      a.status.should eq AccessRequest::APPROVED
      assert_localdate_equal(a.date_approved, [2012, 4, 3])
    end
    it "saves the access request" do
      a = Factory(:access_request, status: AccessRequest::CREATED)
      a.approve!
      a.reload

      a.status.should eq AccessRequest::APPROVED

      assert_localdate_equal(a.date_approved, [2012, 4, 3])
    end
  end
  describe "reject!" do
    it "sets the status to REJECTED" do
      a = Factory(:access_request, status: AccessRequest::CREATED)
      a.reject!
      a.status.should eq AccessRequest::REJECTED
    end
    it "saves the access request" do
      a = Factory(:access_request, status: AccessRequest::CREATED)
      a.reject!

      a.reload
      a.status.should eq AccessRequest::REJECTED
    end
  end
  describe "place request" do
    it "sends email to super users and creates an access request" do
      u = Factory(:user)
      p = Factory(:papyrus)
      super_role = Factory(:role, name: Role::SUPERUSER_ROLE_NAME)
      su = Factory(:user, role: super_role, status:"A")
      su2 = Factory(:user, role: super_role, status:"A")

      mock_mail = mock(Object)

      Notifier.should_receive(:notify_superusers_of_papyrus_access_request).and_return(mock_mail)
      mock_mail.should_receive(:deliver)

      AccessRequest.place_request(u, p)
      AccessRequest.find_by_user_id_and_papyrus_id_and_status!(u, p, AccessRequest::CREATED)
    end
  end
  describe "scopes" do
    before :each do
      @created = Factory(:access_request, status: AccessRequest::CREATED)
      @approved = Factory(:access_request, status: AccessRequest::APPROVED, date_approved: Time.new(2012, 2, 3))
      @rejected = Factory(:access_request, status: AccessRequest::REJECTED)
    end
    it "pending requests" do
      AccessRequest.pending_requests.should eq [@created]
    end
    it "approved requests" do
      AccessRequest.approved_requests.should eq [@approved]
    end
    it "rejected requests" do
      AccessRequest.rejected_requests.should eq [@rejected]
    end
  end
  describe "validations" do
    it{should validate_presence_of :user_id}
    it{should validate_presence_of :papyrus_id}
    it{should validate_presence_of :date_requested}
    it "should validate unique (user_id, papyrus_id) combination" do
      u = Factory(:user)
      p = Factory(:papyrus)
      Factory(:access_request, user: u, papyrus: p).should be_valid
      FactoryGirl.build(:access_request, user: u, papyrus: p).should_not be_valid
    end
    it "should have it's status as one of the allowed values" do
      FactoryGirl.build(:access_request, status: AccessRequest::CREATED).should be_valid
      FactoryGirl.build(:access_request, status: AccessRequest::APPROVED, date_approved: Time.new(2011, 4, 5)).should be_valid
      FactoryGirl.build(:access_request, status: AccessRequest::REJECTED).should be_valid
      FactoryGirl.build(:access_request, status: "RANDOM").should_not be_valid
      FactoryGirl.build(:access_request, status: "created").should_not be_valid
      FactoryGirl.build(:access_request, status: nil).should_not be_valid
    end
    it "should have an approved date if status is approved" do
      FactoryGirl.build(:access_request, status: "APPROVED", date_approved: nil).should_not be_valid
    end
    it "should have a requested date that is not greater than current date" do
      FactoryGirl.build(:access_request, date_requested: '10/08/2300').should_not be_valid
    end
    it "should validate approved date is less than current date" do
      FactoryGirl.build(:access_request, status: AccessRequest::APPROVED, date_approved: '10/02/2999').should_not be_valid
    end
    it "should validate approved date is greater than requested date" do
      FactoryGirl.build(:access_request, status: AccessRequest::APPROVED, date_requested: '13/12/2000', date_approved: '13/11/2000').should_not be_valid
      FactoryGirl.build(:access_request, status: AccessRequest::APPROVED, date_requested: '13/10/2000', date_approved: '13/11/2000').should be_valid
    end
  end

  it "returns formatted date requested" do
    request = Factory.build(:access_request, date_requested: '13/12/2010')
    request.formatted_date_requested.should eq '2010-12-13'
  end
  it "returns formatted date approved" do
    request = Factory.build(:access_request, date_requested: '13/12/2010', date_approved: '15/1/2011')
    request.formatted_date_approved.should eq '2011-01-15'
  end
  it "handles timezones" do
    request = Factory.build(:access_request, date_requested: Date.new(2011, 6, 3), date_approved: Date.new(1000, 3, 2))
    request.formatted_date_requested.should eq '2011-06-03'
    request.formatted_date_approved.should eq '1000-03-02'
  end

end
