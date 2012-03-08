require 'spec_helper'


describe Papyrus do
  it { should validate_presence_of :inventory_id }
  it "should validate inventory id is unique" do
    Factory(:papyrus)
    should validate_uniqueness_of :inventory_id
  end
end
