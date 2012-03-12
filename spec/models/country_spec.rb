require 'spec_helper'


describe Country do
  describe "associations" do
    pending { should have_many :papyri }
  end
  describe "validations" do
    it { should validate_presence_of :name }
    it "should validate name is unique" do
      Factory(:country)
      should validate_uniqueness_of :name
    end
  end
end