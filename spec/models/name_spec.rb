require 'spec_helper'

describe Name do
  describe "Associations" do
    it { should belong_to :papyrus }
  end
  describe "Validations" do
    it { should validate_presence_of :papyrus_id }
    it { should validate_presence_of :name }

    it { should ensure_length_of(:name).is_at_most(64) }
    it { should ensure_length_of(:role).is_at_most(32) }

    it "validates uniqueness of name within a papyrus" do
      p = FactoryGirl.create(:papyrus)
      p2= FactoryGirl.create(:papyrus)

      n = FactoryGirl.create(:name, name: 'name', papyrus: p)

      FactoryGirl.build(:name, name: 'name', papyrus: p).should_not be_valid
      FactoryGirl.build(:name, name: 'name', papyrus: p2).should be_valid
    end

    it "should ensure role is either AUT or ASN" do
      FactoryGirl.build(:name, role: nil).should be_valid
      FactoryGirl.build(:name, role: 'AUT').should be_valid
      FactoryGirl.build(:name, role: 'ASN').should be_valid

      FactoryGirl.build(:name, role: 'something_else').should_not be_valid
    end

    it { should ensure_length_of(:role_note).is_at_most(127) }
    it { should ensure_length_of(:added_information).is_at_most(255) }
    it { should ensure_length_of(:date).is_at_most(255) }
    it { should ensure_length_of(:ordering).is_at_most(1) }
    it "checks ordering is in A-Z (after upcasing)" do
      ('a'..'z').each do |letter|
        FactoryGirl.create(:name, ordering: 'a').should be_valid
      end
      ('A'..'Z').each do |letter|
        FactoryGirl.create(:name, ordering: 'a').should be_valid
      end
    end
    it "checks numbers are invalid" do
      (0..9).each do |digit|
        FactoryGirl.build(:name, ordering: digit).should_not be_valid
      end
    end
  end
  it "should upcase ordering" do
    n = FactoryGirl.create(:name, ordering: 'a')
    n.save!

    n.ordering.should eq 'A'

    n.reload

    n.ordering.should eq 'A'
  end
  describe "default ordering" do
    it "should order by ordering" do
      %w(B C D A F E).each do |letter|
        FactoryGirl.create(:name, ordering: letter)
      end
      Name.all.map(&:ordering).should eq %w(A B C D E F)
    end
  end

  describe "human_readable_role" do
    it "should return the key" do
      FactoryGirl.build(:name, role: 'AUT').human_readable_role.should eq 'Author'
      FactoryGirl.build(:name, role: 'ASN').human_readable_role.should eq 'Associate'

      FactoryGirl.build(:name, role: 'Anything else').human_readable_role.should eq nil
      FactoryGirl.build(:name, role: nil).human_readable_role.should eq nil
    end
  end
end
