require 'spec_helper'

require 'rexml/document'

describe Papyriinfo do
  before :all do
    @old_url_options = ActionController::Base.default_url_options
    new_url_options = {host: 'localhost:3000'}
    ActionController::Base.default_url_options = new_url_options
  end
  after :all do
    ActionController::Base.default_url_options = @old_url_options
  end
  before :each do

    greek = FactoryGirl.create(:language, code: 'grc', name: 'Greek')
    coptic = FactoryGirl.create(:language, code: 'cop', name: 'Coptic')

    paraliterary = FactoryGirl.create(:genre, name: 'Paraliterary')

    @opts = {
      mqt_number: 123,
      inventory_number: 'p.macq.4321',
      type_of_text: 'Title',
      summary: 'A summary',
      physical_location: 'Second cupboard from the right',
      language_ids: [greek.id, coptic.id],
      material: 'papyrus',
      dimensions: '24 x 11 mm',
      paleographic_description: 'Paleographic description.',
      date_from: -123,
      date_to: 123,
      date_note: 'Date details',
      origin_details: 'Details of origin',
      source_of_acquisition: 'Acquisition Source',
      keywords: 'abc def ghi',
      genre: paraliterary,
      original_text: 'The original text',
      translated_text: 'The translated text',
      publications: 'the publications',
      conservation_note: 'taped together',
      preservation_note: 'held in glass',
      other_characteristics: 'lovely',
      lines_of_text: '11 lines on the front',
      recto_verso_note: 'ltr recto',
    }
  end

  describe "with_zip" do
    it "deletes the temp archive" do
      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE)
      saved_zip_file = nil
      Papyriinfo.with_zip do |zip_file|
        saved_zip_file = zip_file
      end
      saved_zip_file.path.should be_nil # i.e. has been "unlink"ed
    end
    it "matches the expected structures" do
      expected_files = Dir.glob(Rails.root.join('spec', 'test_data', 'expected_zip', "*").to_s)
      expected_filenames = expected_files.map {|path| File.basename(path)}

      p = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::VISIBLE, id: 12345, mqt_number: 123))
      make_names(p)

      q = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::PUBLIC, id: 23456, mqt_number: 234))
      make_names(q)

      Papyriinfo.with_zip do |zip_file|
        files_hash = extract_returning_files_hash(zip_file)

        files_hash.keys.sort.should eq expected_filenames.sort
        expected_files.each do |path_to_expected_file|
          name_of_expected_file = File.basename(path_to_expected_file)
          actual_file_path = files_hash[name_of_expected_file]

          if actual_file_path.nil?
            raise "Expected downloaded zip to include file #{name_of_expected_file} but did not find it. Found #{files_hash.keys}."
          else
            actual = File.read(actual_file_path)
            expected = File.read(path_to_expected_file)
            normalise_xml(actual).should eq normalise_xml(expected)
          end
        end

      end
    end
  end
  describe "xml_data" do
    it "works for public records" do
      p = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::PUBLIC, id: 12345))
      make_names(p)

      expected = File.read(Rails.root.join('spec', 'test_data', 'public.xml'))
      actual = Papyriinfo.send(:xml_data, p)

      normalise_xml(actual).should eq normalise_xml(expected)
    end
    it "works correctly for visible records" do
      p = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::VISIBLE, id: 12345))
      make_names(p)

      expected = File.read(Rails.root.join('spec', 'test_data', 'visible.xml'))
      actual = Papyriinfo.send(:xml_data, p)

      normalise_xml(actual).should eq normalise_xml(expected)
    end
    it "XML-escapes the content" do
      p = FactoryGirl.create(:papyrus, @opts.merge(
          publications: '&',
          translated_text: '&',
          original_text: '&',
          keywords: '&',
          source_of_acquisition: '&',
          origin_details: '&',
          date_note: '&',
          paleographic_description: '&',
          recto_verso_note: '&',
          lines_of_text: '&',
          preservation_note: '&',
          conservation_note: '&',
          dimensions: '&',
          other_characteristics: '&',
          material: '&',
          physical_location: '&',
          summary: '\'',
          inventory_number: '>',
          type_of_text: '&',
          visibility: Papyrus::PUBLIC,
          id: 12345

        )
      )
      FactoryGirl.create(:name, papyrus: p, role: Name::AUTHOR, name: '<', ordering: 'A')
      FactoryGirl.create(:name, papyrus: p, role: Name::ASSOCIATE, name: '&&', ordering: 'C')

      expected = File.read(Rails.root.join('spec', 'test_data', 'escaped.xml'))
      actual = Papyriinfo.send(:xml_data, p)

      normalise_xml(actual).should eq normalise_xml(expected)
    end
    describe "changes requested by Hugh" do
      it "returns the MQT number if a title doesn't exist" do
        p = FactoryGirl.create(:papyrus, type_of_text: nil, mqt_number: 999, visibility: Papyrus::VISIBLE)
        to_xml(p).should =~ /<title>MQT 999<\/title>/
      end
      it "contains an institution tag" do
        p = FactoryGirl.create(:papyrus, type_of_text: nil, mqt_number: 999, visibility: Papyrus::VISIBLE)
        REXML::XPath.first(to_dom(p), "/TEI/teiHeader/fileDesc/sourceDesc/msDesc/institution").text.should eq "Macquarie Museum"
      end
      it "omits condition tag if it has no content" do
        p = FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE)
        REXML::XPath.first(to_dom(p), "//condition").should be_nil
      end
      it "uses the apis keyword scheme" do
        p = FactoryGirl.create(:papyrus, keywords: 'something', visibility: Papyrus::PUBLIC)
        document = to_dom(p)
        REXML::XPath.first(document, "/TEI/teiHeader/encodingDesc/classDecl/taxonomy[@xml:id='apis']/desc").text.should eq "APIS keywords are controlled locally at the institution level. They are not necessarily consistent."
        REXML::XPath.first(document, "//textClass/keywords/@scheme").value.should eq "#apis"
      end
      it "uses acquisition instead of provenance" do
        p = FactoryGirl.create(:papyrus, source_of_acquisition: 'Acqui', visibility: Papyrus::PUBLIC)
        document = to_dom(p)
        REXML::XPath.first(document, "//provenance").should be_nil
        REXML::XPath.first(document, "//acquisition/p").text.should eq "Acqui"
      end
      it "has the dimensions in a note" do
        p = FactoryGirl.create(:papyrus, dimensions: '30x20cm', visibility: Papyrus::PUBLIC)
        document = to_dom(p)
        REXML::XPath.first(document, "//physDesc/objectDesc/supportDesc/support/note[@type='dimensions']").text.should eq "30x20cm"
      end
      it "has other_characteristics in the support tag" do
        p = FactoryGirl.create(:papyrus, other_characteristics: 'other charas', visibility: Papyrus::PUBLIC)
        document = to_dom(p)
        REXML::XPath.first(document, "//ab[@type='other']").should be_nil
        REXML::XPath.first(document, "//support").text.strip.should eq 'other charas'
      end
    end
  end
end
def make_names(papyrus)
  FactoryGirl.create(:name, papyrus: papyrus, role: Name::AUTHOR, name: 'Author Two', ordering: 'B')
  FactoryGirl.create(:name, papyrus: papyrus, role: Name::AUTHOR, name: 'Author One', ordering: 'A')
  FactoryGirl.create(:name, papyrus: papyrus, role: Name::ASSOCIATE, name: 'Non-author', ordering: 'C')
end

def to_xml(papyrus)
  Papyriinfo.send(:xml_data, papyrus)
end
def to_dom(papyrus)
  REXML::Document.new(Papyriinfo.send(:xml_data, papyrus))
end
