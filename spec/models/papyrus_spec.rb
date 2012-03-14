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
  describe "associations" do
    it { should belong_to :country_of_origin }
    it { should belong_to :genre }
    it { should have_and_belong_to_many :languages }
  end
  describe "validations" do
    it { should validate_presence_of :inventory_id }
    it "should validate inventory id is unique" do
      Factory(:papyrus)
      should validate_uniqueness_of :inventory_id
    end
    it "should not be greater than current year" do
      papyrus = Factory.build(:papyrus, date_year: 9999, date_era: 'CE')
      papyrus.should_not be_valid
    end
    it "should be able to be greater than current year if BCE" do
      papyrus = Factory.build(:papyrus, date_year: 9999, date_era: 'BCE')
      papyrus.should be_valid
    end
    it "should have a valid date era" do
      papyrus = Factory.build(:papyrus, date_year: 2012, date_era: 'FDW')
      papyrus.should_not be_valid
    end
    it "should not allow a year 0" do
      papyrus = Factory.build(:papyrus, date_year: 0, date_era: 'CE')
      papyrus.should_not be_valid
    end
    it "should accept both nil or both present" do
      [[123, 'CE'], [nil, nil]].each do |year, era|
        Factory(:papyrus, date_year: year, date_era: era).should be_valid
      end
    end
    it "should reject when just one date datum present" do
      [[123, nil], [nil, 'CE']].each do |year, era|
        Factory.build(:papyrus, date_year: year, date_era: era).should_not be_valid
      end
    end
    it "should work if the year changes" do
      today = mock(Object)
      today.should_receive(:year).twice.and_return(2012, 2013)
      Date.should_receive(:today).twice.and_return(today)
      load 'app/models/papyrus.rb'
      papyrus = Papyrus.new(inventory_id: 'sdfh', date_year: 2013, date_era: 'CE')
      papyrus.should_not be_valid
      papyrus.should be_valid
    end
    it "should reject width less than or equal to zero when provided" do
      Factory.build(:papyrus, width: 0).should_not be_valid
      Factory.build(:papyrus, width: -10).should_not be_valid
    end
    it "should accept nil or positive width" do
      Factory.build(:papyrus, width: nil).should be_valid
      Factory.build(:papyrus, width: 10).should be_valid
    end
    it "should reject height less than or equal to zero when provided" do
      Factory.build(:papyrus, height: 0).should_not be_valid
      Factory.build(:papyrus, height: -10).should_not be_valid
    end
    it "should accept nil or positive height" do
      Factory.build(:papyrus, height: nil).should be_valid
      Factory.build(:papyrus, height: 10).should be_valid
    end
    it { should validate_presence_of :visibility }
    it "should only accept either hidden, visible or public" do
      Factory.build(:papyrus, visibility: Papyrus::HIDDEN).should be_valid
      Factory.build(:papyrus, visibility: Papyrus::VISIBLE).should be_valid
      Factory.build(:papyrus, visibility: Papyrus::PUBLIC).should be_valid
      Factory.build(:papyrus, visibility: "RANDOM").should_not be_valid
      Factory.build(:papyrus, visibility: "public").should_not be_valid
    end

  end
  describe "languages_csv" do
    it "should return the languages in alphabetical order" do
      p = Factory(:papyrus)
      p.languages.create(name: 'B')
      p.languages.create(name: 'A')
      p.languages.create(name: 'C')

      p.languages_csv.should eq 'A, B, C'
    end
  end

  describe "has_translation?" do
    it "should return true for a translation present" do
      p = Papyrus.new(translated_text: 'some translation')
      p.human_readable_has_translation.should eq 'Yes'
    end
    it "should return false for a blank translation" do
      p = Papyrus.new(translated_text: '')
      p.human_readable_has_translation.should eq 'No'
    end
    it "should return false for a nil translation" do
      p = Papyrus.new(translated_text: nil)
      p.human_readable_has_translation.should eq 'No'
    end
  end

  it "should order by inventory_id by default" do
    Factory(:papyrus, inventory_id: 'B')
    Factory(:papyrus, inventory_id: 'D')
    Factory(:papyrus, inventory_id: 'A')
    Factory(:papyrus, inventory_id: 'C')

    Papyrus.pluck(:inventory_id).should eq %w{A B C D}

  end

  describe "search" do
    before :each do
      Factory(:papyrus, inventory_id: "k")
      Factory(:papyrus, languages: "")
      Factory(:papyrus, general_note: "")
      Factory(:papyrus, note: "")
      Factory(:papyrus, paleographic_description: "")
      Factory(:papyrus, recto_note: "")
      Factory(:papyrus, verso_note: "")
      Factory(:papyrus, country_of_origin: "")
      Factory(:papyrus, origin_details: "")
      Factory(:papyrus, source_of_acquisition: "")
      Factory(:papyrus, preservation_note: "")
      Factory(:papyrus, genre: "")
      Factory(:papyrus, language_note: "")
      Factory(:papyrus, summary: "")
      Factory(:papyrus, translated_text: "")
    end
  end

end
