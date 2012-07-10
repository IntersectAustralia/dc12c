# coding: utf-8
require 'spec_helper'


describe Papyrus do
  it "deletes images, access_requests, names, connections on destroy" do
    p = FactoryGirl.create(:papyrus)
    FactoryGirl.create(:access_request, papyrus: p)
    FactoryGirl.create(:name, papyrus: p)
    FactoryGirl.create(:image, papyrus: p)

    related_papyrus = FactoryGirl.create(:papyrus)
    FactoryGirl.create(:connection, papyrus: p, related_papyrus: related_papyrus)

    AccessRequest.count.should eq 1
    Name.count.should eq 1
    Image.count.should eq 1
    Connection.count.should eq 1
    Papyrus.count.should eq 2

    p.destroy

    AccessRequest.count.should eq 0
    Name.count.should eq 0
    Image.count.should eq 0
    Connection.count.should eq 0
    Papyrus.all.should eq [related_papyrus]
  end
  describe "formatted_pmacq_number" do
    it "concatenates volume number and item number" do
      FactoryGirl.build(:papyrus, volume_number: 'X', item_number: 123).formatted_pmacq_number.should eq 'X 123'
    end
    it "nils all other combinations of volume number and item number" do
      FactoryGirl.build(:papyrus, volume_number: nil, item_number: nil).formatted_pmacq_number.should be_nil
      FactoryGirl.build(:papyrus, volume_number: '1', item_number: nil).formatted_pmacq_number.should be_nil
      FactoryGirl.build(:papyrus, volume_number: nil, item_number: 123).formatted_pmacq_number.should be_nil
    end
  end
  describe "visibility helpers" do
    before :each do
      @p = FactoryGirl.create(:papyrus, visibility: Papyrus::HIDDEN)
    end
    describe "make_public!" do
      it "saves and updates visibility accordingly" do
        @p.make_public!

        @p.reload
        @p.visibility.should eq Papyrus::PUBLIC
        @p.should be_persisted
      end
    end
    describe "make_visible!" do
      it "saves and updates visibility accordingly" do
        @p.make_visible!

        @p.reload
        @p.visibility.should eq Papyrus::VISIBLE
        @p.should be_persisted
      end
    end
    describe "make_hidden!" do
      it "saves and updates visibility accordingly" do
        @p = FactoryGirl.create(:papyrus, visibility: Papyrus::PUBLIC)
        @p.make_hidden!

        @p.reload
        @p.visibility.should eq Papyrus::HIDDEN
        @p.should be_persisted
      end
    end
  end
  describe "basic_field" do
    it "should return true for basic fields" do
      Papyrus.basic_field(:formatted_mqt_number).should be_true
    end
    it "should return false for detailed fields" do
      Papyrus.basic_field(:physical_location).should be_false
    end
  end
  describe "detailed_field" do
    it "should return true for detailed fields" do
      Papyrus.detailed_field(:physical_location).should be_true
    end
    it "should return false for full fields" do
      Papyrus.detailed_field(:mqt_note).should be_false
    end
  end
  describe "full_field" do
    it "should return true for full fields" do
      Papyrus.full_field(:recto_verso_note).should be_true
    end
    it "should return false for non-full fields" do
      Papyrus.full_field(:physical_location).should be_false
    end
  end
  describe "formatted date" do
    it "shows a date range" do
      papyrus = FactoryGirl.create(:papyrus, date_from: -234, date_to: 224)
      papyrus.formatted_date.should eq "234 BCE - 224 CE"
    end
    it "shows a specific date BCE" do
      papyrus = FactoryGirl.create(:papyrus, date_from: -1234)
      papyrus.formatted_date.should eq "1234 BCE"
    end
    it "shows a specific date CE" do
      papyrus = FactoryGirl.create(:papyrus, date_from: 1534)
      papyrus.formatted_date.should eq "1534 CE"
    end
    it "should be nil if no data" do
      papyrus = FactoryGirl.create(:papyrus, date_from: nil, date_to: nil)
      papyrus.formatted_date.should be_nil
    end
  end
  describe "dates" do
    describe "nils" do
      before :each do
        @p = FactoryGirl.create(:papyrus)
      end
      it { @p.date_from_year.should be_nil }
      it { @p.date_to_year.should be_nil }
      it { @p.date_from_era.should be_nil }
      it { @p.date_to_era.should be_nil }
    end
    describe "bce" do
      it "handles negatives" do
        p = FactoryGirl.create(:papyrus, date_from: -233, date_to: -1)
        p.date_from_year.should eq 233
        p.date_from_era.should eq 'BCE'

        p.date_to_year.should eq 1
        p.date_to_era.should eq 'BCE'
      end
      it "handles positives" do
        p = FactoryGirl.create(:papyrus, date_from: 23, date_to: 1023)

        p.date_from_year.should eq 23
        p.date_from_era.should eq 'CE'
        p.date_to_year.should eq 1023
        p.date_to_era.should eq 'CE'
      end
    end
  end
  describe "associations" do
    it { should belong_to :genre }
    it { should have_and_belong_to_many :languages }
    it { should have_many :access_requests }
    it { should have_many :images }
    it { should have_many :names }
    it { should have_many :connections }
    it { should have_and_belong_to_many :collections }
  end
  describe "validations" do
    it { should validate_presence_of :mqt_number }
    it { should ensure_length_of(:mqt_note).is_at_most(2048) }
    it { should ensure_length_of(:inventory_number).is_at_most(64) }
    it { should ensure_length_of(:apis_id).is_at_most(32) }
    it { should ensure_length_of(:physical_location).is_at_most(255) }
    it { should ensure_length_of(:dimensions).is_at_most(511) }
    it { should ensure_length_of(:general_note).is_at_most(512) }
    it { should ensure_length_of(:lines_of_text).is_at_most(1023) }
    it { should ensure_length_of(:paleographic_description).is_at_most(1023) }
    it { should ensure_length_of(:origin_details).is_at_most(255) }
    it { should ensure_length_of(:source_of_acquisition).is_at_most(255) }
    it { should ensure_length_of(:preservation_note).is_at_most(1023) }
    it { should ensure_length_of(:conservation_note).is_at_most(1023) }
    it { should ensure_length_of(:summary).is_at_most(1024) }
    it { should ensure_length_of(:language_note).is_at_most(255) }
    it { should ensure_length_of(:original_text).is_at_most(4000) }
    it { should ensure_length_of(:translated_text).is_at_most(4000) }
    it { should ensure_length_of(:date_note).is_at_most(511) }
    it { should ensure_length_of(:other_characteristics).is_at_most(1023) }
    it { should ensure_length_of(:material).is_at_most(255) }
    it { should ensure_length_of(:recto_verso_note).is_at_most(511) }
    it { should ensure_length_of(:type_of_text).is_at_most(255) }
    it { should ensure_length_of(:modern_textual_dates).is_at_most(511) }
    it { should ensure_length_of(:publications).is_at_most(511) }
    it { should ensure_length_of(:keywords).is_at_most(511) }

    it "should validate mqt number is unique" do
      FactoryGirl.create(:papyrus)
      should validate_uniqueness_of :mqt_number
    end
    describe "mqt_number" do
      it "rejects non-numerics" do
        FactoryGirl.build(:papyrus, mqt_number: 'abc').should_not be_valid
      end
      it "rejects fractions" do
        FactoryGirl.build(:papyrus, mqt_number: '11.2').should_not be_valid
        FactoryGirl.build(:papyrus, mqt_number: 11.2).should_not be_valid
      end
      it "rejects negatives" do
        FactoryGirl.build(:papyrus, mqt_number: '-1').should_not be_valid
        FactoryGirl.build(:papyrus, mqt_number: -1).should_not be_valid
      end
    end

    describe "trismegistos id" do
      it "should be numeric" do
        papyrus = FactoryGirl.build(:papyrus, trismegistos_id: 'aaa')
        papyrus.should_not be_valid
      end
      it "should be grater than 0" do
        papyrus = FactoryGirl.build(:papyrus, trismegistos_id: 0)
        papyrus.should_not be_valid
        papyrus = FactoryGirl.build(:papyrus, trismegistos_id: -10)
        papyrus.should_not be_valid
        papyrus = FactoryGirl.build(:papyrus, trismegistos_id: 10)
        papyrus.should be_valid
      end
      it "rejects fractions" do
        FactoryGirl.build(:papyrus, trismegistos_id: 1.2).should_not be_valid
      end
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

    describe "p.macq number" do
      it "validates volume number is I-X" do
        %w{I II III IV V VI VII VIII IX X}.each do |volume|
          FactoryGirl.build(:papyrus, volume_number: volume, item_number: 1).should be_valid
        end
        FactoryGirl.build(:papyrus, volume_number: 'garbage', item_number: 1).should_not be_valid
      end
      it "validates item_number as positive integer" do
        FactoryGirl.build(:papyrus, volume_number: 'I', item_number: -1).should_not be_valid
        FactoryGirl.build(:papyrus, volume_number: 'I', item_number: 0).should_not be_valid
        FactoryGirl.build(:papyrus, volume_number: 'I', item_number: 0.5).should_not be_valid
        FactoryGirl.build(:papyrus, volume_number: 'I', item_number: 5).should be_valid
      end
      it "validates item number uniqueness" do
        FactoryGirl.create(:papyrus, volume_number: 'I', item_number: 1)
        should validate_uniqueness_of :item_number
      end
      it "accepts item/volume absent" do
        FactoryGirl.build(:papyrus, volume_number: nil, item_number: nil).should be_valid
      end
      it "accepts item/volume present" do
        FactoryGirl.build(:papyrus, volume_number: 'X', item_number: 123).should be_valid
      end
      it "rejects item only" do
        FactoryGirl.build(:papyrus, volume_number: nil, item_number: 123).should_not be_valid
      end
      it "rejects volume only" do
        FactoryGirl.build(:papyrus, volume_number: 'I', item_number: nil).should_not be_valid
      end
    end

  end
  describe "languages_csv" do
    it "should return the languages in alphabetical order" do
      p = FactoryGirl.create(:papyrus)
      p.languages.create!(name: 'B', code: 'x')
      p.languages.create!(name: 'A', code: 'y')
      p.languages.create!(name: 'C', code: 'z')

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

  describe "genre_name" do
    it "should return the genre name" do
      genre = Genre.new(name: 'A genre')
      p = Papyrus.new()
      p.genre = genre
      p.genre_name.should eq 'A genre'
    end
    it "should be nil for nil genre" do
      p = Papyrus.new()
      p.genre_name.should be_nil
    end
  end

  it "should order by mqt number by default" do
    FactoryGirl.create(:papyrus, mqt_number: 2, inventory_number: 'B')
    FactoryGirl.create(:papyrus, mqt_number: 4, inventory_number: 'D')
    FactoryGirl.create(:papyrus, mqt_number: 1, inventory_number: 'A')
    FactoryGirl.create(:papyrus, mqt_number: 3, inventory_number: 'C')

    Papyrus.pluck(:inventory_number).should eq %w{A B C D}

  end

  describe "authors" do
    it "returns authors only, not associates" do
      papyrus = FactoryGirl.create(:papyrus)
      a1 = FactoryGirl.create(:name, papyrus: papyrus, role: Name::AUTHOR, name: 'a1')
      FactoryGirl.create(:name, papyrus: papyrus, role: Name::ASSOCIATE)
      a2 = FactoryGirl.create(:name, papyrus: papyrus, role: Name::AUTHOR, name: 'a2')

      papyrus.authors.should eq [a1, a2]

    end
  end

  describe "split_keywords" do
    it "splits on whitespace" do
      keywords = "a b c\nd\te"
      p = FactoryGirl.create(:papyrus, keywords: keywords)
      p.split_keywords.should eq %w(a b c d e)
    end
    it "handles nil" do
      FactoryGirl.create(:papyrus).split_keywords.should eq []
    end
  end
  describe "anonymous view" do
    it "does nothing for public records" do
      p = FactoryGirl.create(:papyrus, visibility: Papyrus::PUBLIC)
      p.anonymous_view.should eq p
    end
    it "dies on hidden records" do
      p = FactoryGirl.create(:papyrus, visibility: Papyrus::HIDDEN)
      proc { p.anonymous_view }.should raise_error
    end
    it "hides information for visible records" do
      genre = FactoryGirl.create(:genre, name: 'genre')
      coptic = FactoryGirl.create(:language, code: 'cop', name: 'Coptic')
      greek = FactoryGirl.create(:language, code: 'grc', name: 'Greek')

      name_a = FactoryGirl.create(:name, name: 'a', ordering: 'A')
      name_b = FactoryGirl.create(:name, name: 'b', ordering: 'B')

      related_papyrus = FactoryGirl.create(:papyrus)

      connection = FactoryGirl.create(:connection, related_papyrus: related_papyrus, description: 'something')

      attrs = {
        id: 12345,
        mqt_number: 2,
        inventory_number: 'inventory_number',
        apis_id: 'apis_id',
        trismegistos_id: 22,
        date_from: -1,
        date_to: 5,
        lines_of_text: 'lines_of_text',
        paleographic_description: 'paleographic_description',
        origin_details: 'origin_details',
        summary: 'summary',
        dimensions: 'dimensions',
        genre: genre,
        language_ids: [coptic.id, greek.id],
        material: 'material',
        publications: 'publications',
        volume_number: 'I',
        item_number: 3,
        name_ids: [name_a.id, name_b.id],
        connection_ids: [connection.id],

        physical_location: 'physical_location',
        date_note: 'date_note',
        general_note: 'general_note',
        source_of_acquisition: 'source_of_acquisition',
        preservation_note: 'preservation_note',
        conservation_note: 'conservation_note',
        language_note: 'language_note',
        translated_text: 'translated_text',
        other_characteristics: 'other_characteristics',
        type_of_text: 'type_of_text',
        keywords: 'keywords',

        mqt_note: 'mqt_note',
        original_text: 'original_text',
        recto_verso_note: 'recto_verso_note',
        modern_textual_dates: 'modern_textual_dates'
      }

      p = FactoryGirl.create(:papyrus, attrs.merge(visibility: Papyrus::VISIBLE))

      anonymous = p.anonymous_view
      p.equal?(anonymous).should be_false # bug in rspec so we use a weird spec: https://github.com/rspec/rspec-expectations/issues/115

      expected_values = {
        id: 12345,
        mqt_number: 2,
        inventory_number: 'inventory_number',
        apis_id: 'apis_id',
        trismegistos_id: 22,
        date_from: -1,
        date_to: 5,
        lines_of_text: 'lines_of_text',
        paleographic_description: 'paleographic_description',
        origin_details: 'origin_details',
        summary: 'summary',
        dimensions: 'dimensions',
        genre: genre,
        language_ids: [coptic.id, greek.id],
        material: 'material',
        publications: 'publications',
        volume_number: 'I',
        item_number: 3,
        names: [name_a, name_b],
        connections: [connection],

        physical_location: nil,
        date_note: nil,
        general_note: nil,
        source_of_acquisition: nil,
        preservation_note: nil,
        conservation_note: nil,
        language_note: nil,
        translated_text: nil,
        other_characteristics: nil,
        type_of_text: nil,
        keywords: nil,

        mqt_note: nil,
        original_text: nil,
        recto_verso_note: nil,
        modern_textual_dates: nil
      }
      actual_values = expected_values.keys.reduce({}) do |actual, method|
        actual.merge(method => anonymous.send(method))
      end

      actual_values.should eq expected_values
    end
  end

  describe "xml date functions" do
    describe "date functions" do
      it "should return nil for nils" do
        p = FactoryGirl.build(:papyrus)

        p.xml_date_from.should be_nil
        p.xml_date_to.should be_nil
      end
      it "should pad with zeros" do
        FactoryGirl.build(:papyrus, date_from: -1).xml_date_from.should eq "-0001"
        FactoryGirl.build(:papyrus, date_to: 1).xml_date_to.should eq "0001"
      end
      it "doesn't add too many zeroes" do
        FactoryGirl.build(:papyrus, date_from: -1000).xml_date_from.should eq "-1000"
        FactoryGirl.build(:papyrus, date_to: 1000).xml_date_to.should eq "1000"

      end
    end

    describe "title" do
      it "should return the title if it exists" do
        title = "abc"
        FactoryGirl.build(:papyrus, type_of_text: title).xml_title.should eq title
      end
      it "should return the formatted mqt number otherwise" do
        mqt = 122
        FactoryGirl.build(:papyrus, mqt_number: mqt).xml_title.should eq "MQT 122"
      end

    end
  end

# search tests are in spec/models/papyrus_searching_spec.rb

end
