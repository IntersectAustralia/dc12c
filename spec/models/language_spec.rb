require 'spec_helper'

describe Language do
  describe "associations" do
    it { should have_and_belong_to_many :papyri }
  end
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it "should validate name is unique" do
      FactoryGirl.create(:language)
      should validate_uniqueness_of :name
    end
    it "should validate code is unique" do
      FactoryGirl.create(:language)
      should validate_uniqueness_of :code
    end
  end

  it "should default to ordering by name" do
    FactoryGirl.create(:language, name: 'A', code: 'C')
    FactoryGirl.create(:language, name: 'D', code: 'E')
    FactoryGirl.create(:language, name: 'C', code: 'F')
    FactoryGirl.create(:language, name: 'B', code: 'A')

    Language.all.map(&:name).should eq %w(A B C D)
  end
end
