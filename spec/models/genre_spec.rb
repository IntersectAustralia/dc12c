require 'spec_helper'


describe Genre do
  describe "associations" do
    it { should have_many :papyri }
  end
  describe "validations" do
    it { should validate_presence_of :name }
    it "should validate name is unique" do
      FactoryGirl.create(:genre)
      should validate_uniqueness_of :name
    end
  end
end