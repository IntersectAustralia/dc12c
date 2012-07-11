# coding: utf-8
require 'spec_helper'

describe Papyrus do
  describe "search by mqt_number" do
    it "should find by mqt_number" do
      super_role = FactoryGirl.create(:role, name: Role::SUPERUSER_ROLE_NAME)
      admin = FactoryGirl.create(:user, role: super_role, status: "A")
      researcher_role = FactoryGirl.create(:role, name: Role::RESEARCHER_ROLE_NAME)
      researcher = FactoryGirl.create(:user, role: researcher_role, status: 'A')

      visible = FactoryGirl.create(:papyrus, mqt_number: 123, visibility: Papyrus::VISIBLE)
      hidden = FactoryGirl.create(:papyrus, mqt_number: 234, visibility: Papyrus::HIDDEN)

      anonymous = nil

      Papyrus.search(anonymous, [visible.mqt_number.to_s]).should eq [visible]
      Papyrus.search(researcher, [visible.mqt_number.to_s]).should eq [visible]
      Papyrus.search(admin, [visible.mqt_number.to_s]).should eq [visible]

      Papyrus.search(anonymous, [hidden.mqt_number.to_s]).should eq []
      Papyrus.search(researcher, [hidden.mqt_number.to_s]).should eq [hidden]
      Papyrus.search(admin, [hidden.mqt_number.to_s]).should eq [hidden]

      Papyrus.search(admin, ['12']).should eq [visible] # partial match
    end
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
          results = Papyrus.advanced_search(@user, preservation_note: 'no biro')
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
        it "should not find by multiple parameters" do
          results = Papyrus.advanced_search(@user, language_note: 'looks', translated_text: 'me striKe The')
          results.should eq []
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
          results = Papyrus.advanced_search(@user, preservation_note: 'no biro')
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
        it "should not find by multiple parameters" do
          results = Papyrus.advanced_search(@user, language_note: 'looks', translated_text: 'me striKe The')
          results.should eq []
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
          results = Papyrus.advanced_search(@user, preservation_note: 'no biro')
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
        it "should AND multiple parameters" do
          results = Papyrus.advanced_search(@user, language_note: 'looks', translated_text: 'me striKe The')
          results.should eq []
        end
      end # advanced mode

    end # by admin

  end

  describe "advanced searching by dates" do
    before :each do
      super_role = FactoryGirl.create(:role, name: Role::SUPERUSER_ROLE_NAME)

      @one_bce = FactoryGirl.create(:papyrus, date_from: -1, visibility: Papyrus::HIDDEN)
      @one_ce = FactoryGirl.create(:papyrus, date_from: 1, visibility: Papyrus::HIDDEN)
      @admin = FactoryGirl.create(:user)
      @admin.role = super_role
      @admin.save
    end

    it "should find by exact year" do
      Papyrus.advanced_search(@admin, date_from: 1, date_to: 1).should eq [@one_ce]
    end
    it "should find gte" do
      Papyrus.advanced_search(@admin, date_from: -2).should eq [@one_bce, @one_ce]
      Papyrus.advanced_search(@admin, date_from: -1).should eq [@one_bce, @one_ce]
      Papyrus.advanced_search(@admin, date_from: 1).should eq [@one_ce]
    end
    it "should find lte" do
      Papyrus.advanced_search(@admin, date_to: 2).should eq [@one_bce, @one_ce]
      Papyrus.advanced_search(@admin, date_to: 1).should eq [@one_bce, @one_ce]
      Papyrus.advanced_search(@admin, date_to: -1).should eq [@one_bce]
    end
  end
  # TODO We elect to not write researcher/anonymous tests for date searching as this file is getting too long (and logically, they are well-covered)

  describe "advanced searching should AND subterms " do
    before :each do
      @p1 = FactoryGirl.create(:papyrus, inventory_number: 'pmacq1', visibility: Papyrus::PUBLIC)
      @p2 = FactoryGirl.create(:papyrus, inventory_number: 'pmacq2', visibility: Papyrus::PUBLIC)
      @p3 = FactoryGirl.create(:papyrus, inventory_number: 'pmacq3', visibility: Papyrus::PUBLIC)

      @anonymous = nil
    end
    specify do
      Papyrus.advanced_search(@anonymous, inventory_number: 'pmacq 1').should eq [@p1]
    end
  end
end
