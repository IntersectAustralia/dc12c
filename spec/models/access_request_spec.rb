# coding: utf-8
require 'spec_helper'


describe AccessRequest do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :papyrus }
  end
  describe "approve!" do
    it "sets the status to APPROVED" do
      a = Factory(:access_request, status: AccessRequest::CREATED)
      a.approve!
      a.status.should eq AccessRequest::APPROVED
    end
    it "saves the access request" do
      a = Factory(:access_request, status: AccessRequest::CREATED)
      a.approve!
      a.reload

      a.status.should eq AccessRequest::APPROVED
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
      @approved = Factory(:access_request, status: AccessRequest::APPROVED)
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
    it "should validate unique (user_id, papyrus_id) combination" do
      u = Factory(:user)
      p = Factory(:papyrus)
      Factory(:access_request, user: u, papyrus: p).should be_valid
      FactoryGirl.build(:access_request, user: u, papyrus: p).should_not be_valid
    end
    it "should have it's status as one of the allowed values" do
      FactoryGirl.build(:access_request, status: "CREATED").should be_valid
      FactoryGirl.build(:access_request, status: "APPROVED").should be_valid
      FactoryGirl.build(:access_request, status: "REJECTED").should be_valid
      FactoryGirl.build(:access_request, status: "RANDOM").should_not be_valid
      FactoryGirl.build(:access_request, status: "created").should_not be_valid
      FactoryGirl.build(:access_request, status: nil).should_not be_valid
    end
  end
end
