# coding: utf-8
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
    it {should have_many :access_requests}
  end
  describe "validations" do
    it { should validate_presence_of :inventory_id }
    it { should ensure_length_of(:inventory_id).is_at_most(32) }
    it { should ensure_length_of(:general_note).is_at_most(255) }
    it { should ensure_length_of(:note).is_at_most(255) }
    it { should ensure_length_of(:paleographic_description).is_at_most(255) }
    it { should ensure_length_of(:recto_note).is_at_most(255) }
    it { should ensure_length_of(:verso_note).is_at_most(255) }
    it { should ensure_length_of(:origin_details).is_at_most(255) }
    it { should ensure_length_of(:source_of_acquisition).is_at_most(255) }
    it { should ensure_length_of(:preservation_note).is_at_most(255) }
    it { should ensure_length_of(:paleographic_description).is_at_most(255) }
    it { should ensure_length_of(:summary).is_at_most(255) }
    it { should ensure_length_of(:language_note).is_at_most(255) }
    it { should ensure_length_of(:original_text).is_at_most(4096) }
    it { should ensure_length_of(:translated_text).is_at_most(4096) }

    it "should not be able to be greater than 4 digits long" do
      papyrus = FactoryGirl.build(:papyrus, date_year: 10000, date_era: 'BCE')
      papyrus.should_not be_valid
      papyrus.errors[:date_year].should include("is too long (maximum is 4 characters)")
    end

    it "should validate inventory id is unique" do
      Factory(:papyrus)
      should validate_uniqueness_of :inventory_id
    end
    it "should not be greater than current year" do
      papyrus = FactoryGirl.build(:papyrus, date_year: 9999, date_era: 'CE')
      papyrus.should_not be_valid
    end
    it "should be able to be greater than current year if BCE" do
      papyrus = FactoryGirl.build(:papyrus, date_year: 9999, date_era: 'BCE')
      papyrus.should be_valid
    end
    it "should have a valid date era" do
      papyrus = FactoryGirl.build(:papyrus, date_year: 2012, date_era: 'FDW')
      papyrus.should_not be_valid
    end
    it "should not allow a year 0" do
      papyrus = FactoryGirl.build(:papyrus, date_year: 0, date_era: 'CE')
      papyrus.should_not be_valid
    end
    it "should accept both nil or both present" do
      [[123, 'CE'], [nil, nil]].each do |year, era|
        Factory(:papyrus, date_year: year, date_era: era).should be_valid
      end
    end
    it "should reject when just one date datum present" do
      [[123, nil], [nil, 'CE']].each do |year, era|
        FactoryGirl.build(:papyrus, date_year: year, date_era: era).should_not be_valid
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
      FactoryGirl.build(:papyrus, width: 0).should_not be_valid
      FactoryGirl.build(:papyrus, width: -10).should_not be_valid
    end
    it "should accept nil or positive width" do
      FactoryGirl.build(:papyrus, width: nil).should be_valid
      FactoryGirl.build(:papyrus, width: 10).should be_valid
    end
    it "should reject height less than or equal to zero when provided" do
      FactoryGirl.build(:papyrus, height: 0).should_not be_valid
      FactoryGirl.build(:papyrus, height: -10).should_not be_valid
    end
    it "should accept nil or positive height" do
      FactoryGirl.build(:papyrus, height: nil).should be_valid
      FactoryGirl.build(:papyrus, height: 10).should be_valid
    end
    it { should validate_presence_of :visibility }
    it "should only accept either hidden, visible or public" do
      FactoryGirl.build(:papyrus, visibility: Papyrus::HIDDEN).should be_valid
      FactoryGirl.build(:papyrus, visibility: Papyrus::VISIBLE).should be_valid
      FactoryGirl.build(:papyrus, visibility: Papyrus::PUBLIC).should be_valid
      FactoryGirl.build(:papyrus, visibility: "RANDOM").should_not be_valid
      FactoryGirl.build(:papyrus, visibility: "public").should_not be_valid
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
      latin = Factory(:language, name: 'Latin')
      england = Factory(:country, name: 'England')
      drama = Factory(:genre, name: 'Drama')
      @p1 = Factory(:papyrus, inventory_id: "l23")
      @p2 = Factory(:papyrus, languages: [latin])
      @p3 = Factory(:papyrus, general_note: "screen wipe")
      @p4 = Factory(:papyrus, note: "light bulb")
      @p5 = Factory(:papyrus, paleographic_description: "Sydney")
      @p6 = Factory(:papyrus, recto_note: "staedtler")
      @p7 = Factory(:papyrus, verso_note: "uniball")
      @p8 = Factory(:papyrus, country_of_origin: england)
      @p9 = Factory(:papyrus, origin_details: "best ever")
      @p10 = Factory(:papyrus, source_of_acquisition: "eBay")
      @p11 = Factory(:papyrus, preservation_note: "no biro allowed")
      @p12 = Factory(:papyrus, genre: drama)
      @p13 = Factory(:papyrus, language_note: "it looks funny")
      @p14 = Factory(:papyrus, summary: "it's all greek to me")
      @p15 = Factory(:papyrus, inventory_id: 'p.macq1234', translated_text: "These strike me as Chinese")
      @p16 = Factory(:papyrus, original_text: "Έμπασυ στο Κολωνάκι")
    end
    describe "simple" do
      it "should find by inventory id" do
        results = Papyrus.search(['l23'])
        results.should eq [@p1]
      end
      it "should find by languages and be case-insensitive" do
        results = Papyrus.search(['latin'])
        results.should eq [@p2]
      end
      it "should find by general note" do
        results = Papyrus.search(['screen'])
        results.should eq [@p3]
      end
      it "should find by note" do
        results = Papyrus.search(['light bulb'])
        results.should eq [@p4]
      end
      it "should find by paleographic description" do
        results = Papyrus.search(['sydney'])
        results.should eq [@p5]
      end
      it "should find by recto note" do
        results = Papyrus.search(['staedtler'])
        results.should eq [@p6]
      end
      it "should find by verso note" do
        results = Papyrus.search(['uniball'])
        results.should eq [@p7]
      end
      it "should find by country of origin" do
        results = Papyrus.search(['England'])
        results.should eq [@p8]
      end
      it "should find by origin details" do
        results = Papyrus.search(['ever'])
        results.should eq [@p9]
      end
      it "should find by source of acquisition" do
        results = Papyrus.search(['ebay'])
        results.should eq [@p10]
      end
      it "should find by preservation note" do
        results = Papyrus.search(['no', 'biro', 'please'])
        results.should eq [@p11]
      end
      it "should find by genre" do
        results = Papyrus.search(['drama'])
        results.should eq [@p12]
      end
      it "should find by language note" do
        results = Papyrus.search(['funny'])
        results.should eq [@p13]
      end
      it "should find by summary" do
        results = Papyrus.search(["it's all greek to me"])
        results.should eq [@p14]
      end
      it "should find by translated text" do
        results = Papyrus.search(['Chinese', 'strike'])
        results.should eq [@p15]
      end
      it "should find across multiple fields" do
        results = Papyrus.search(['EnglanD', 'Bulb', 'aLl'])
        results.should eq [@p4, @p7, @p8, @p11, @p14]
      end
    end

    describe "advanced" do
      it "should find by general note" do
        results = Papyrus.advanced_search(general_note: 'screen')
        results.should eq [@p3]
      end
      it "should find by note" do
        results = Papyrus.advanced_search(note: 'light bulb')
        results.should eq [@p4]
      end
      it "should find by paleographic description" do
        results = Papyrus.advanced_search(paleographic_description: 'sydney')
        results.should eq [@p5]
      end
      it "should find by recto note" do
        results = Papyrus.advanced_search(recto_note: 'staedtler')
        results.should eq [@p6]
      end
      it "should find by verso note" do
        results = Papyrus.advanced_search(verso_note: 'uniball')
        results.should eq [@p7]
      end
      it "should find by origin details" do
        results = Papyrus.advanced_search(origin_details: 'ever')
        results.should eq [@p9]
      end
      it "should find by source of acquisition" do
        results = Papyrus.advanced_search(source_of_acquisition: 'ebay')
        results.should eq [@p10]
      end
      it "should find by preservation note" do
        results = Papyrus.advanced_search(preservation_note: 'no biro please')
        results.should eq [@p11]
      end
      it "should find by language note" do
        results = Papyrus.advanced_search(language_note: 'funny')
        results.should eq [@p13]
      end
      it "should find by summary" do
        results = Papyrus.advanced_search(summary: "it's all greek to me")
        results.should eq [@p14]
      end
      it "should find by original text" do
        results = Papyrus.advanced_search(original_text: "ΚοΛωνάκι")
        results.should eq [@p16]
      end
      it "should find by translated text" do
        results = Papyrus.advanced_search(translated_text: 'Chinese strike')
        results.should eq [@p15]
      end
      it "should find by multiple parameters" do
        results = Papyrus.advanced_search(inventory_id: 'p.macq1234', translated_text: 'me striKe The')
        results.should eq [@p15]
      end
    end

  end

end
