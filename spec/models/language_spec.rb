require 'spec_helper'


describe Language do
  describe "associations" do
    it { should have_and_belong_to_many :papyri }
  end
  describe "validations" do
    it { should validate_presence_of :name }
    it "should validate name is unique" do
      FactoryGirl.create(:language)
      should validate_uniqueness_of :name
    end
  end
end
