require 'spec_helper'


describe Papyrus do
  describe "formatted date" do
    it "should have year and era" do
      papyrus = Factory(:papyrus, date_year: 234, date_era: 'BCE')
      papyrus.formatted_date.should eq "234 BCE"
    end
    it "should be nil if no data" do
      papyrus = Factory(:papyrus, date_year: nil, date_era: nil)
      papyrus.formatted_date.should be_nil
    end
  end
  it { should validate_presence_of :inventory_id }
  it "should validate inventory id is unique" do
    Factory(:papyrus)
    should validate_uniqueness_of :inventory_id
  end
end
