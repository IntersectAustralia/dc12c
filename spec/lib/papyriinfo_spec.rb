require 'spec_helper'

require 'rexml/document'

describe Papyriinfo do
  describe "with_zip" do
    it "something" do
      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE)
      saved_zip_file = nil
      Papyriinfo.with_zip do |zip_file|
        saved_zip_file = zip_file
      end
      saved_zip_file.path.should be_nil # i.e. has been "unlink"ed
    end
  end
  describe "xml_data" do
    before :each do
      greek = FactoryGirl.create(:language, code: 'grc', name: 'Greek')
      coptic = FactoryGirl.create(:language, code: 'cop', name: 'Coptic')

      paraliterary = FactoryGirl.create(:genre, name: 'Paraliterary')

      @opts = {
        id: 12345,
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
    it "works for public records" do
      p = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::PUBLIC))

      FactoryGirl.create(:name, papyrus: p, role: Name::AUTHOR, name: 'Author Two', ordering: 'B')
      FactoryGirl.create(:name, papyrus: p, role: Name::AUTHOR, name: 'Author One', ordering: 'A')
      FactoryGirl.create(:name, papyrus: p, role: Name::ASSOCIATE, name: 'Non-author', ordering: 'C')

      expected = File.read(Rails.root.join('spec', 'sample.xml'))
      actual = Papyriinfo.send(:xml_data, p)

      normalise_xml(actual).should eq normalise_xml(expected)
    end
    it "works correctly for visible records" do
      p = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::VISIBLE))

      FactoryGirl.create(:name, papyrus: p, role: Name::AUTHOR, name: 'Author Two', ordering: 'B')
      FactoryGirl.create(:name, papyrus: p, role: Name::AUTHOR, name: 'Author One', ordering: 'A')
      FactoryGirl.create(:name, papyrus: p, role: Name::ASSOCIATE, name: 'Non-author', ordering: 'C')

      expected = File.read(Rails.root.join('spec', 'visible.xml'))
      actual = Papyriinfo.send(:xml_data, p)

      normalise_xml(actual).should eq normalise_xml(expected)
    end
  end
end
