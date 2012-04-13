# coding: utf-8
require 'spec_helper'


describe Papyrus do
  describe "formatted date" do
    it "shows a date range" do
      papyrus = Factory(:papyrus, date_from: -234, date_to: 224)
      papyrus.formatted_date.should eq "234 BCE - 224 CE"
    end
    it "shows a specific date BCE" do
      papyrus = Factory(:papyrus, date_from: -1234)
      papyrus.formatted_date.should eq "1234 BCE"
    end
    it "shows a specific date CE" do
      papyrus = Factory(:papyrus, date_from: 1534)
      papyrus.formatted_date.should eq "1534 CE"
    end
    it "should be nil if no data" do
      papyrus = Factory(:papyrus, date_from: nil, date_to: nil)
      papyrus.formatted_date.should be_nil
    end
  end
  describe "dates" do
    describe "nils" do
      before :each do
        @p = Factory(:papyrus)
      end
      it { @p.date_from_year.should be_nil }
      it { @p.date_to_year.should be_nil }
      it { @p.date_from_era.should be_nil }
      it { @p.date_to_era.should be_nil }
    end
    describe "bce" do
      it "handles negatives" do
        p = Factory(:papyrus, date_from: -233, date_to: -1)
        p.date_from_year.should eq 233
        p.date_from_era.should eq 'BCE'

        p.date_to_year.should eq 1
        p.date_to_era.should eq 'BCE'
      end
      it "handles positives" do
        p = Factory(:papyrus, date_from: 23, date_to: 1023)

        p.date_from_year.should eq 23
        p.date_from_era.should eq 'CE'
        p.date_to_year.should eq 1023
        p.date_to_era.should eq 'CE'
      end
    end
  end
  describe "associations" do
    it { should belong_to :country_of_origin }
    it { should belong_to :genre }
    it { should have_and_belong_to_many :languages }
    it { should have_many :access_requests }
    it { should have_many :images }
  end
  describe "validations" do
    it { should validate_presence_of :mqt_number }
    it { should ensure_length_of(:inventory_id).is_at_most(32) }
    it { should ensure_length_of(:dimensions).is_at_most(511) }
    it { should ensure_length_of(:general_note).is_at_most(255) }
    it { should ensure_length_of(:lines_of_text).is_at_most(1023) }
    it { should ensure_length_of(:paleographic_description).is_at_most(1023) }
    it { should ensure_length_of(:recto_verso_note).is_at_most(511) }
    it { should ensure_length_of(:origin_details).is_at_most(255) }
    it { should ensure_length_of(:source_of_acquisition).is_at_most(255) }
    it { should ensure_length_of(:preservation_note).is_at_most(1023) }
    it { should ensure_length_of(:conservation_note).is_at_most(1023) }
    it { should ensure_length_of(:paleographic_description).is_at_most(1023) }
    it { should ensure_length_of(:summary).is_at_most(255) }
    it { should ensure_length_of(:language_note).is_at_most(255) }
    it { should ensure_length_of(:original_text).is_at_most(4096) }
    it { should ensure_length_of(:translated_text).is_at_most(4096) }
    it { should ensure_length_of(:date_note).is_at_most(511) }
    it { should ensure_length_of(:material).is_at_most(255) }
    it { should ensure_length_of(:other_characteristics).is_at_most(1023) }
    it { should ensure_length_of(:type_of_text).is_at_most(255) }
    it { should ensure_length_of(:modern_textual_dates).is_at_most(511) }
    it { should ensure_length_of(:publications).is_at_most(127) }

    it "should validate mqt number is unique" do
      Factory(:papyrus)
      should validate_uniqueness_of :mqt_number
    end

    describe "dates" do
      it "should not be able to be greater than 4 digits long" do
        papyrus = FactoryGirl.build(:papyrus, date_from: -10000)
        papyrus.should_not be_valid
        # papyrus.errors[:date_from].should include("is too long (maximum is 4 characters)") # TODO
      end
      it "checks date_from is present if date_to is present" do
        FactoryGirl.build(:papyrus, date_to: 23).should_not be_valid
      end
      it "checks to date is after from date" do
        FactoryGirl.build(:papyrus, date_from: 1, date_to: 1).should_not be_valid
        FactoryGirl.build(:papyrus, date_from: 1, date_to: -1).should_not be_valid
        FactoryGirl.build(:papyrus, date_from: 1, date_to: 2).should be_valid
      end
      it "should not be greater than current year" do
        papyrus = FactoryGirl.build(:papyrus, date_from: 9999)
        papyrus.should_not be_valid

        papyrus = FactoryGirl.build(:papyrus, date_from: 999, date_to: 9999)
        papyrus.should_not be_valid
      end
      it "should be able to be greater than current year if BCE" do
        papyrus = FactoryGirl.build(:papyrus, date_from: -9999)
        papyrus.should be_valid
      end
      it "should not allow a year 0" do
        papyrus = FactoryGirl.build(:papyrus, date_from: 0)
        papyrus.should_not be_valid

        papyrus = FactoryGirl.build(:papyrus, date_to: 0)
        papyrus.should_not be_valid
      end
      it "should work if the year changes" do
        today = mock(Object)
        today.should_receive(:year).at_least(:once).and_return(2012, 2013)
        Date.should_receive(:today).at_least(:once).and_return(today)
        load 'app/models/papyrus.rb'
        papyrus = Papyrus.new(mqt_number: 1000, date_from: 2013)
        papyrus.should_not be_valid
        papyrus.should be_valid
      end
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
      @p4 = Factory(:papyrus, lines_of_text: "light bulb")
      @p5 = Factory(:papyrus, paleographic_description: "Sydney")
      @p6 = Factory(:papyrus, recto_verso_note: "staedtler")
      @p8 = Factory(:papyrus, country_of_origin: england)
      @p9 = Factory(:papyrus, origin_details: "best ever")
      @p10 = Factory(:papyrus, source_of_acquisition: "eBay")
      @p11 = Factory(:papyrus, preservation_note: "no biro allowed")
      @p12 = Factory(:papyrus, genre: drama)
      @p13 = Factory(:papyrus, language_note: "it looks funny")
      @p14 = Factory(:papyrus, summary: "it's all greek to me")
      @p15 = Factory(:papyrus, inventory_id: 'p.macq1234', translated_text: "These strike me as Chinese")
      @p16 = Factory(:papyrus, original_text: "Έμπασυ στο Κολωνάκι")
      @p17 = Factory(:papyrus, summary: "Έμπασυ στο Κολωνάκι")
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
      it "should find by lines_of_text" do
        results = Papyrus.search(['light bulb'])
        results.should eq [@p4]
      end
      it "should find by paleographic description" do
        results = Papyrus.search(['sydney'])
        results.should eq [@p5]
      end
      it "should find by recto verso note" do
        results = Papyrus.search(['staedtler'])
        results.should eq [@p6]
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
        results.should eq [@p4, @p8, @p11, @p14]
      end
      it "should find prefix of words in utf8 searches" do
        results = Papyrus.search(['Έμ'])
        results.should eq [@p17]
      end
    end

    describe "advanced" do
      it "should find by general note" do
        results = Papyrus.advanced_search(general_note: 'screen')
        results.should eq [@p3]
      end
      it "should find by note" do
        results = Papyrus.advanced_search(lines_of_text: 'light bulb')
        results.should eq [@p4]
      end
      it "should find by paleographic description" do
        results = Papyrus.advanced_search(paleographic_description: 'sydney')
        results.should eq [@p5]
      end
      it "should find by recto verso note" do
        results = Papyrus.advanced_search(recto_verso_note: 'staedtler')
        results.should eq [@p6]
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
