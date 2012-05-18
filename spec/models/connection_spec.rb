require 'spec_helper'

describe Connection do
  describe "Associations" do
    it { should belong_to :papyrus }
    it { should belong_to :related_papyrus }
  end
  describe "Validations" do
    it { should validate_presence_of :papyrus_id }
    it { should validate_presence_of :related_papyrus_id }
    it { should validate_presence_of :description }

    it "should validate related_papyrus_id is not equal to papyrus_id" do
      p = FactoryGirl.create(:papyrus)
      FactoryGirl.build(:connection, papyrus: p, related_papyrus: p).should_not be_valid
    end

    it "should validate uniqueness of related_papyrus_id scoped to papyrus_id" do
      p = FactoryGirl.create(:papyrus)
      p2 = FactoryGirl.create(:papyrus)
      p3 = FactoryGirl.create(:papyrus)

      n = FactoryGirl.create(:connection, related_papyrus: p3, papyrus: p)

      FactoryGirl.build(:connection, related_papyrus: p3, papyrus: p).should_not be_valid
      FactoryGirl.build(:connection, related_papyrus: p3, papyrus: p2).should be_valid
    end

    it { should ensure_length_of(:description).is_at_most(255) }
  end
  it "should default order to description" do
    FactoryGirl.create(:connection, description: 'b')
    FactoryGirl.create(:connection, description: 'c')
    FactoryGirl.create(:connection, description: 'a')

    Connection.all.map(&:description).should eq %w(a b c)
  end
end
