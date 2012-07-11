require 'spec_helper'

describe Collection do
  describe "Associations" do
    it { should have_and_belong_to_many :papyri }
  end
  describe "Validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :keywords }
    it { should ensure_length_of(:title).is_at_most(255) }
    it { should ensure_length_of(:description).is_at_most(512) }
    it { should ensure_length_of(:keywords).is_at_most(255) }
    it "should validate title is unique" do
      FactoryGirl.create(:collection)
      should validate_uniqueness_of :title
    end
  end
  describe "rif-cs" do
    it "makes the right xml" do
      collection = FactoryGirl.create(:collection)
      collection.to_rifcs.should be_present
      raise collection.to_rifcs.to_xml.inspect
    end
  end
end
