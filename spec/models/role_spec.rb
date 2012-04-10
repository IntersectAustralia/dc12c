require 'spec_helper'

describe Role do
  describe "researcher?" do
    it "should return true for researcher" do
      r = Role.new
      r.name = 'Researcher'
      r.should be_researcher
    end
    it "should return true for anything else" do
      names = ['Superuser', 'Admin', 'Administrator']
      names.each do |name|
        r = Role.new
        r.name = name
        r.save!

        r.should_not be_researcher
      end
    end
  end
  describe "Associations" do
    it { should have_many(:users) }
  end
  
  describe "Scopes" do
    describe "By name" do
      it "should order the roles by name and include all roles" do

        r1 = Role.new
        r1.name = "bcd"
        r2 = Role.new
        r2.name = "aaa"
        r3 = Role.new
        r3.name = "abc"

        r1.save!
        r2.save!
        r3.save!

        Role.by_name.should eq([r2, r3, r1])
      end
    end
  end
    
  describe "Validations" do
    it { should validate_presence_of(:name) }

    describe "Duplicate checks" do
      before :each do
        @name = 'abc'

        r = Role.new
        r.name = @name
        r.save!
      end

      it "should reject duplicate names" do
        with_duplicate_name = Role.new
        with_duplicate_name.name = @name
        with_duplicate_name.should_not be_valid
      end

      it "should reject duplicate names identical except for case" do
        with_duplicate_name = Role.new
        with_duplicate_name.name = 'ABC' # Role 'abc' setup in before
        with_duplicate_name.should_not be_valid
      end
    end
  end


end
