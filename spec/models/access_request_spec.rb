# coding: utf-8
require 'spec_helper'


describe AccessRequest do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :papyrus }
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
