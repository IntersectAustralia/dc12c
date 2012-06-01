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
    it { should ensure_length_of(:mqt_note).is_at_most(255) }
    it { should ensure_length_of(:inventory_number).is_at_most(64) }
    it { should ensure_length_of(:apis_id).is_at_most(32) }
    it { should ensure_length_of(:physical_location).is_at_most(255) }
    it { should ensure_length_of(:dimensions).is_at_most(511) }
    it { should ensure_length_of(:general_note).is_at_most(512) }
    it { should ensure_length_of(:lines_of_text).is_at_most(1023) }
    it { should ensure_length_of(:paleographic_description).is_at_most(1023) }
    it { should ensure_length_of(:recto_verso_note).is_at_most(511) }
    it { should ensure_length_of(:origin_details).is_at_most(255) }
    it { should ensure_length_of(:source_of_acquisition).is_at_most(255) }
    it { should ensure_length_of(:preservation_note).is_at_most(1023) }
    it { should ensure_length_of(:conservation_note).is_at_most(1023) }
    it { should ensure_length_of(:paleographic_description).is_at_most(1023) }
    it { should ensure_length_of(:summary).is_at_most(1024) }
    it { should ensure_length_of(:language_note).is_at_most(255) }
    it { should ensure_length_of(:original_text).is_at_most(4096) }
    it { should ensure_length_of(:translated_text).is_at_most(4096) }
    it { should ensure_length_of(:date_note).is_at_most(511) }
    it { should ensure_length_of(:material).is_at_most(255) }
    it { should ensure_length_of(:other_characteristics).is_at_most(1023) }
    it { should ensure_length_of(:type_of_text).is_at_most(255) }
    it { should ensure_length_of(:modern_textual_dates).is_at_most(511) }
    it { should ensure_length_of(:publications).is_at_most(511) }
    it { should ensure_length_of(:keywords).is_at_most(255) }

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

  describe "search" do

    let(:latin) { FactoryGirl.create(:language, name: 'Latin') }
    let(:demotic) { FactoryGirl.create(:language, name: 'Demotic') }
    let(:coptic) { FactoryGirl.create(:language, name: 'Coptic') }
    let(:drama) { FactoryGirl.create(:genre, name: 'Drama') }

    def make_papyrus(user, number, visibility, values)
      ## hack >> papyrus = FactoryGirl.create(:papyrus, values.merge(visibility: visibility, modern_textual_dates:number.to_s)), modif papyrus.inspect as well
      has_user = (user ? ' *ACCESS' : '')
      papyrus = FactoryGirl.create(:papyrus, values.merge(visibility: visibility, modern_textual_dates:"[#{number} #{visibility} #{values}#{has_user}]"))
      instance_variable_set("@p#{number}", papyrus)
      FactoryGirl.create(:access_request, papyrus: papyrus, user: user, status: AccessRequest::APPROVED, date_requested: Time.new - 10, date_approved: Time.new) if user
    end

    def make_papyri(start_number, visibility, user = nil)
      make_papyrus(user, start_number + 1, visibility, inventory_number: "l23", languages:[demotic, coptic])
      make_papyrus(user, start_number + 2, visibility, languages: [latin])
      make_papyrus(user, start_number + 3, visibility, general_note: "screen wipe")
      make_papyrus(user, start_number + 4, visibility, lines_of_text: "light bulb")
      make_papyrus(user, start_number + 5, visibility, paleographic_description: "Sydney")
      make_papyrus(user, start_number + 6, visibility, recto_verso_note: "staedtler")
      make_papyrus(user, start_number + 9, visibility, origin_details: "best ever")
      make_papyrus(user, start_number + 10, visibility, source_of_acquisition: "eBay")
      make_papyrus(user, start_number + 11, visibility, preservation_note: "no biro allowed")
      make_papyrus(user, start_number + 12, visibility, genre: drama)
      make_papyrus(user, start_number + 13, visibility, language_note: "it looks funny")
      make_papyrus(user, start_number + 14, visibility, summary: "it's all greek to me")
      make_papyrus(user, start_number + 15, visibility, translated_text: "These strike me as Chinese")
      make_papyrus(user, start_number + 17, visibility, summary: "Έμπασυ στο Κολωνάκι")
      make_papyrus(user, start_number + 18, visibility, apis_id: "apis")
      make_papyrus(user, start_number + 19, visibility, trismegistos_id: 444)
      make_papyrus(user, start_number + 20, visibility, mqt_note: "aaa")
      make_papyrus(user, start_number + 21, visibility, physical_location: "bbb")
      make_papyrus(user, start_number + 22, visibility, dimensions: "ccc")
      make_papyrus(user, start_number + 23, visibility, date_note: "ddd")
      make_papyrus(user, start_number + 24, visibility, conservation_note: "eee")
      make_papyrus(user, start_number + 25, visibility, translated_text: "fff")
      make_papyrus(user, start_number + 26, visibility, other_characteristics: "ggg")
      make_papyrus(user, start_number + 27, visibility, material: "hhh")
      make_papyrus(user, start_number + 28, visibility, type_of_text: "iii")
    end

    before :each do
      make_papyri(0,"HIDDEN")
      make_papyri(100,"VISIBLE")
      make_papyri(200,"PUBLIC")
    end

    describe "by admin" do

      before :each do
        super_role = FactoryGirl.create(:role, name: Role::SUPERUSER_ROLE_NAME)
        @user = FactoryGirl.create(:user, role: super_role, status:"A")
      end

      describe "in simple mode" do

        it "should find by inventory number" do
          results = Papyrus.search(@user, ['l23'])
          results.should eq [@p1, @p101, @p201]
        end
        it "should find by languages and be case-insensitive" do
          results = Papyrus.search(@user, ['latin'])
          results.should eq [@p2, @p102, @p202]
        end
        it "should find by general note" do
          results = Papyrus.search(@user, ['screen'])
          results.should eq [@p3, @p103, @p203]
        end
        it "should find by lines_of_text" do
          results = Papyrus.search(@user, ['light bulb'])
          results.should eq [@p4, @p104, @p204]
        end
        it "should find by paleographic description" do
          results = Papyrus.search(@user, ['sydney'])
          results.should eq [@p5, @p105, @p205]
        end
        it "should find by recto verso note" do
          results = Papyrus.search(@user, ['staedtler'])
          results.should eq [@p6, @p106, @p206]
        end
        it "should find by origin details" do
          results = Papyrus.search(@user, ['ever'])
          results.should eq [@p9, @p109, @p209]
        end
        it "should find by source of acquisition" do
          results = Papyrus.search(@user, ['ebay'])
          results.should eq [@p10, @p110, @p210]
        end
        it "should find by preservation note" do
          results = Papyrus.search(@user, ['no', 'biro', 'please'])
          results.should eq [@p11, @p111, @p211]
        end
        it "should find by genre" do
          results = Papyrus.search(@user, ['drama'])
          results.should eq [@p12, @p112, @p212]
        end
        it "should find by language note" do
          results = Papyrus.search(@user, ['funny'])
          results.should eq [@p13, @p113, @p213]
        end
        it "should find by summary" do
          results = Papyrus.search(@user, ["it's all greek to me"])
          results.should eq [@p14, @p114, @p214]
        end
        it "should find by translated text" do
          results = Papyrus.search(@user, ['Chinese', 'strike'])
          results.should eq [@p15, @p115, @p215]
        end
        it "should find date note" do
          results = Papyrus.search(@user, ['aaa'])
          results.should eq [@p20, @p120, @p220]
        end
        it "should find by mqt_note" do
          results = Papyrus.search(@user, ['aaa'])
          results.should eq [@p20, @p120, @p220]
        end
        it "should find by apis id" do
          results = Papyrus.search(@user, ['apis'])
          results.should eq [@p18, @p118, @p218]
        end
        it "should find by trismegistos id" do
          results = Papyrus.search(@user, ['444'])
          results.should eq [@p19, @p119, @p219]
        end
        it "should find by physical location" do
          results = Papyrus.search(@user, ['bbb'])
          results.should eq [@p21, @p121, @p221]
        end
        it "should find by dimensions" do
          results = Papyrus.search(@user, ['ccc'])
          results.should eq [@p22, @p122, @p222]
        end
        it "should find by conservation note" do
          results = Papyrus.search(@user, ['eee'])
          results.should eq [@p24, @p124, @p224]
        end
        it "should find by translated text" do
          results = Papyrus.search(@user, ['fff'])
          results.should eq [@p25, @p125, @p225]
        end
        it "should find by other characteristics" do
          results = Papyrus.search(@user, ['ggg'])
          results.should eq [@p26, @p126, @p226]
        end
        it "should find by material" do
          results = Papyrus.search(@user, ['hhh'])
          results.should eq [@p27, @p127, @p227]
        end
        it "should find by type of text/tittle" do
          results = Papyrus.search(@user, ['iii'])
          results.should eq [@p28, @p128, @p228]
        end
        it "should find across multiple fields" do
          results = Papyrus.search(@user, ['Bulb', 'aLl'])
          results.should eq [@p4, @p11, @p14, @p104, @p111, @p114, @p204, @p211, @p214]
        end
        it "should find prefix of words in utf8 searches" do
          results = Papyrus.search(@user, ['Έμ'])
          results.should eq [@p17, @p117, @p217]
        end
      end #simple mode

      describe "in advanced mode" do

        it "should find by general note" do
          results = Papyrus.advanced_search(@user, general_note: 'screen')
          results.should eq [@p3, @p103, @p203]
        end
        it "should find by note" do
          results = Papyrus.advanced_search(@user, lines_of_text: 'light bulb')
          results.should eq [@p4, @p104, @p204]
        end
        it "should find by paleographic description" do
          results = Papyrus.advanced_search(@user, paleographic_description: 'sydney')
          results.should eq [@p5, @p105, @p205]
        end
        it "should find by recto verso note" do
          results = Papyrus.advanced_search(@user, recto_verso_note: 'staedtler')
          results.should eq [@p6, @p106, @p206]
        end
        it "should find by origin details" do
          results = Papyrus.advanced_search(@user, origin_details: 'ever')
          results.should eq [@p9, @p109, @p209]
        end
        it "should find by source of acquisition" do
          results = Papyrus.advanced_search(@user, source_of_acquisition: 'ebay')
          results.should eq [@p10, @p110, @p210]
        end
        it "should find by preservation note" do
          results = Papyrus.advanced_search(@user, preservation_note: 'no biro please')
          results.should eq [@p11, @p111, @p211]
        end
        it "should find by language note" do
          results = Papyrus.advanced_search(@user, language_note: 'funny')
          results.should eq [@p13, @p113, @p213]
        end
        it "should find by summary" do
          results = Papyrus.advanced_search(@user, summary: "it's all greek to me")
          results.should eq [@p14, @p114, @p214]
        end
        it "should find by translated text" do
          results = Papyrus.advanced_search(@user, translated_text: 'Chinese strike')
          results.should eq [@p15, @p115, @p215]
        end
        it "should find by multiple parameters" do
          results = Papyrus.advanced_search(@user, language_note: 'looks', translated_text: 'me striKe The')
          results.should eq [@p13, @p15, @p113, @p115, @p213, @p215]
        end
      end # advanced mode

    end # by admin

    describe "by anonymous" do

      before :each do
        @user = nil
      end

      describe "in simple mode" do

        it "should find by inventory number" do
          results = Papyrus.search(@user, ['l23'])
          results.should eq [@p101, @p201]
        end
        it "should find by languages and be case-insensitive" do
          results = Papyrus.search(@user, ['latin'])
          results.should eq [@p102, @p202]
        end
        it "should find by general note" do
          results = Papyrus.search(@user, ['screen'])
          results.should eq [@p203]
        end
        it "should find by lines_of_text" do
          results = Papyrus.search(@user, ['light bulb'])
          results.should eq [@p104, @p204]
        end
        it "should find by paleographic description" do
          results = Papyrus.search(@user, ['sydney'])
          results.should eq [@p105, @p205]
        end
        it "should find by recto verso note" do
          results = Papyrus.search(@user, ['staedtler'])
          results.should eq [@p206]
        end
        it "should find by origin details" do
          results = Papyrus.search(@user, ['ever'])
          results.should eq [@p109, @p209]
        end
        it "should find by source of acquisition" do
          results = Papyrus.search(@user, ['ebay'])
          results.should eq [@p210]
        end
        it "should find by preservation note" do
          results = Papyrus.search(@user, ['no', 'biro', 'please'])
          results.should eq [@p211]
        end
        it "should find by genre" do
          results = Papyrus.search(@user, ['drama'])
          results.should eq [@p112, @p212]
        end
        it "should find by language note" do
          results = Papyrus.search(@user, ['funny'])
          results.should eq [@p213]
        end
        it "should find by summary" do
          results = Papyrus.search(@user, ["it's all greek to me"])
          results.should eq [@p114, @p214]
        end
        it "should find by translated text" do
          results = Papyrus.search(@user, ['Chinese', 'strike'])
          results.should eq [@p215]
        end
        it "should find date note" do
          results = Papyrus.search(@user, ['aaa'])
          results.should eq [@p220]
        end
        it "should find by mqt_note" do
          results = Papyrus.search(@user, ['aaa'])
          results.should eq [@p220]
        end
        it "should find by apis id" do
          results = Papyrus.search(@user, ['apis'])
          results.should eq [@p118, @p218]
        end
        it "should find by trismegistos id" do
          results = Papyrus.search(@user, ['444'])
          results.should eq [@p119, @p219]
        end
        it "should find by physical location" do
          results = Papyrus.search(@user, ['bbb'])
          results.should eq [@p221]
        end
        it "should find by dimensions" do
          results = Papyrus.search(@user, ['ccc'])
          results.should eq [@p122, @p222]
        end
        it "should find by conservation note" do
          results = Papyrus.search(@user, ['eee'])
          results.should eq [@p224]
        end
        it "should find by translated text" do
          results = Papyrus.search(@user, ['fff'])
          results.should eq [@p225]
        end
        it "should find by other characteristics" do
          results = Papyrus.search(@user, ['ggg'])
          results.should eq [@p226]
        end
        it "should find by material" do
          results = Papyrus.search(@user, ['hhh'])
          results.should eq [@p127, @p227]
        end
        it "should find by type of text/tittle" do
          results = Papyrus.search(@user, ['iii'])
          results.should eq [@p228]
        end
        it "should find across multiple fields" do
          results = Papyrus.search(@user, ['Bulb', 'aLl'])
          results.should eq [@p104, @p114, @p204, @p211, @p214]
        end
        it "should find prefix of words in utf8 searches" do
          results = Papyrus.search(@user, ['Έμ'])
          results.should eq [@p117, @p217]
        end
      end #simple mode

      describe "in advanced mode" do

        it "should find by general note" do
          results = Papyrus.advanced_search(@user, general_note: 'screen')
          results.should eq [@p203]
        end
        it "should find by lines of text" do
          results = Papyrus.advanced_search(@user, lines_of_text: 'light bulb')
          results.should eq [@p104, @p204]
        end
        it "should find by paleographic description" do
          results = Papyrus.advanced_search(@user, paleographic_description: 'sydney')
          results.should eq [@p105, @p205]
        end
        it "should find by recto verso note" do
          results = Papyrus.advanced_search(@user, recto_verso_note: 'staedtler')
          results.should eq [@p206]
        end
        it "should find by origin details" do
          results = Papyrus.advanced_search(@user, origin_details: 'ever')
          results.should eq [@p109, @p209]
        end
        it "should find by source of acquisition" do
          results = Papyrus.advanced_search(@user, source_of_acquisition: 'ebay')
          results.should eq [@p210]
        end
        it "should find by preservation note" do
          results = Papyrus.advanced_search(@user, preservation_note: 'no biro please')
          results.should eq [@p211]
        end
        it "should find by language note" do
          results = Papyrus.advanced_search(@user, language_note: 'funny')
          results.should eq [@p213]
        end
        it "should find by summary" do
          results = Papyrus.advanced_search(@user, summary: "it's all greek to me")
          results.should eq [@p114, @p214]
        end
        it "should find by translated text" do
          results = Papyrus.advanced_search(@user, translated_text: 'Chinese strike')
          results.should eq [@p215]
        end
        it "should find by multiple parameters" do
          results = Papyrus.advanced_search(@user, language_note: 'looks', translated_text: 'me striKe The')
          results.should eq [@p213, @p215]
        end
      end # advanced mode

    end # by anonymous

    describe "by registered" do

      before :each do
        ordinary_role = FactoryGirl.create(:role, name: "NO_#{Role::SUPERUSER_ROLE_NAME}")
        @user = FactoryGirl.create(:user, role: ordinary_role, status:"A")
        make_papyri(300,"HIDDEN", @user)
        make_papyri(400,"VISIBLE", @user)
        make_papyri(500,"PUBLIC", @user)
      end

      describe "in simple mode" do

        it "should find by inventory number" do
          results = Papyrus.search(@user, ['l23'])
          results.should eq [@p1, @p101, @p201, @p301, @p401, @p501]
          #results.map(&:id).should eq [@p1, @p101, @p201, @p301, @p401, @p501].map(&:id)
        end
        it "should find by languages and be case-insensitive" do
          results = Papyrus.search(@user, ['latin'])
          results.should eq [@p2, @p102, @p202, @p302, @p402, @p502]
        end
        it "should find by general note" do
          results = Papyrus.search(@user, ['screen'])
          results.should eq [@p3, @p103, @p203, @p303, @p403, @p503]
        end
        it "should find by lines_of_text" do
          results = Papyrus.search(@user, ['light bulb'])
          results.should eq [@p4, @p104, @p204, @p304, @p404, @p504]
        end
        it "should find by paleographic description" do
          results = Papyrus.search(@user, ['sydney'])
          results.should eq [@p5, @p105, @p205, @p305, @p405, @p505]
        end
        # recto_verso_note is full
        it "should find by recto verso note" do
          results = Papyrus.search(@user, ['staedtler'])
          results.should eq [@p206, @p306, @p406, @p506]
        end
        it "should find by origin details" do
          results = Papyrus.search(@user, ['ever'])
          results.should eq [@p9, @p109, @p209, @p309, @p409, @p509]
        end
        it "should find by source of acquisition" do
          results = Papyrus.search(@user, ['ebay'])
          results.should eq [@p10, @p110, @p210, @p310, @p410, @p510]
        end
        it "should find by preservation note" do
          results = Papyrus.search(@user, ['no', 'biro', 'please'])
          results.should eq [@p11, @p111, @p211, @p311, @p411, @p511]
        end
        it "should find by genre" do
          results = Papyrus.search(@user, ['drama'])
          results.should eq [@p12, @p112, @p212, @p312, @p412, @p512]
        end
        it "should find by language note" do
          results = Papyrus.search(@user, ['funny'])
          results.should eq [@p13, @p113, @p213, @p313, @p413, @p513]
        end
        it "should find by summary" do
          results = Papyrus.search(@user, ["it's all greek to me"])
          results.should eq [@p14, @p114, @p214, @p314, @p414, @p514]
        end
        it "should find by translated text" do
          results = Papyrus.search(@user, ['Chinese', 'strike'])
          results.should eq [@p15, @p115, @p215, @p315, @p415, @p515]
        end
        it "should find date note" do
          results = Papyrus.search(@user, ['ddd'])
          results.should eq [@p23, @p123, @p223,@p323, @p423, @p523]
        end
        # mqt_note is full
        it "should find by mqt_note" do
          results = Papyrus.search(@user, ['aaa'])
          results.should eq [@p220, @p320, @p420, @p520]
        end
        it "should find by apis id" do
          results = Papyrus.search(@user, ['apis'])
          results.should eq [@p18, @p118, @p218, @p318, @p418, @p518]
        end
        it "should find by trismegistos id" do
          results = Papyrus.search(@user, ['444'])
          results.should eq [@p19, @p119, @p219, @p319, @p419, @p519]
        end
        it "should find by physical location" do
          results = Papyrus.search(@user, ['bbb'])
          results.should eq [@p21, @p121, @p221, @p321, @p421, @p521]
        end
        it "should find by dimensions" do
          results = Papyrus.search(@user, ['ccc'])
          results.should eq [@p22, @p122, @p222, @p322, @p422, @p522]
        end
        it "should find by conservation note" do
          results = Papyrus.search(@user, ['eee'])
          results.should eq [@p24, @p124, @p224, @p324, @p424, @p524]
        end
        it "should find by translated text" do
          results = Papyrus.search(@user, ['fff'])
          results.should eq [@p25, @p125, @p225, @p325, @p425, @p525]
        end
        it "should find by other characteristics" do
          results = Papyrus.search(@user, ['ggg'])
          results.should eq [@p26, @p126, @p226, @p326, @p426, @p526]
        end
        it "should find by material" do
          results = Papyrus.search(@user, ['hhh'])
          results.should eq [@p27, @p127, @p227, @p327, @p427, @p527]
        end
        it "should find by type of text/tittle" do
          results = Papyrus.search(@user, ['iii'])
          results.should eq [@p28, @p128, @p228, @p328, @p428, @p528]
        end
        it "should find across multiple fields" do
          results = Papyrus.search(@user, ['Bulb', 'aLl'])
          results.should eq [@p4, @p11, @p14, @p104, @p111, @p114, @p204, @p211, @p214,
                             @p304, @p311, @p314, @p404, @p411, @p414, @p504, @p511, @p514]
        end
        it "should find prefix of words in utf8 searches" do
          results = Papyrus.search(@user, ['Έμ'])
          results.should eq [@p17, @p117, @p217, @p317, @p417, @p517]
        end
      end #simple mode

      describe "in advanced mode" do

        it "should find by general note" do
          results = Papyrus.advanced_search(@user, general_note: 'screen')
          results.should eq [@p3, @p103, @p203, @p303, @p403, @p503]
        end
        it "should find by note" do
          results = Papyrus.advanced_search(@user, lines_of_text: 'light bulb')
          results.should eq [@p4, @p104, @p204, @p304, @p404, @p504]
        end
        it "should find by paleographic description" do
          results = Papyrus.advanced_search(@user, paleographic_description: 'sydney')
          results.should eq [@p5, @p105, @p205, @p305, @p405, @p505]
        end
        it "should find by recto verso note" do
          results = Papyrus.advanced_search(@user, recto_verso_note: 'staedtler')
          results.should eq [@p206, @p306, @p406, @p506]
        end
        it "should find by origin details" do
          results = Papyrus.advanced_search(@user, origin_details: 'ever')
          results.should eq [@p9, @p109, @p209, @p309, @p409, @p509]
        end
        it "should find by source of acquisition" do
          results = Papyrus.advanced_search(@user, source_of_acquisition: 'ebay')
          results.should eq [@p10, @p110, @p210, @p310, @p410, @p510]
        end
        it "should find by preservation note" do
          results = Papyrus.advanced_search(@user, preservation_note: 'no biro please')
          results.should eq [@p11, @p111, @p211, @p311, @p411, @p511]
        end
        it "should find by language note" do
          results = Papyrus.advanced_search(@user, language_note: 'funny')
          results.should eq [@p13, @p113, @p213, @p313, @p413, @p513]
        end
        it "should find by summary" do
          results = Papyrus.advanced_search(@user, summary: "it's all greek to me")
          results.should eq [@p14, @p114, @p214, @p314, @p414, @p514]
        end
        it "should find by translated text" do
          results = Papyrus.advanced_search(@user, translated_text: 'Chinese strike')
          results.should eq [@p15, @p115, @p215, @p315, @p415, @p515]
        end
        it "should find by multiple parameters" do
          results = Papyrus.advanced_search(@user, language_note: 'looks', translated_text: 'me striKe The')
          results.should eq [@p13, @p15, @p113, @p115, @p213, @p215,
                             @p313, @p315, @p413, @p415, @p513, @p515]
        end
      end # advanced mode

    end # by admin

  end #search
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

end
