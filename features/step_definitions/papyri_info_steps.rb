
Then /^I should receive a zip file "(.*)" containing XMLs like in directory "([^"]*)"$/ do |filename, directory|
  #saves the latest response, unzips it, then compares with a pre-defined flat directory of XMLs
  page.response_headers['Content-Disposition'].should =~ /"#{filename}"$/

  compare_zip_to_expected_files(page.source, directory)
end

Given /I have the test papyri for papyri\.info/ do
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
  p = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::VISIBLE, id: 12345, mqt_number: 123))
  make_names(p)

  q = FactoryGirl.create(:papyrus, @opts.merge(visibility: Papyrus::PUBLIC, id: 23456, mqt_number: 234))
  make_names(q)
end

def make_names(papyrus)
    FactoryGirl.create(:name, papyrus: papyrus, role: Name::AUTHOR, name: 'Author Two', ordering: 'B')
    FactoryGirl.create(:name, papyrus: papyrus, role: Name::AUTHOR, name: 'Author One', ordering: 'A')
    FactoryGirl.create(:name, papyrus: papyrus, role: Name::ASSOCIATE, name: 'Non-author', ordering: 'C')
end

def compare_zip_to_expected_files(response_source, directory)
# this code is largely duplicated in spec/lib/papyriinfo_spec.rb
  zip = save_response_to_file(response_source)
  downloaded_files = extract_returning_files_hash(zip)

  expected_files = Dir.glob(File.join(Rails.root, directory, "/*"))
  expected_filenames = expected_files.map { |path| File.basename(path) }

  downloaded_files.keys.sort.should eq expected_filenames.sort
  expected_files.each do |path_to_expected_file|
    downloaded_file_path = downloaded_files[File.basename(path_to_expected_file)]
    if downloaded_file_path.nil?
      raise "Expected downloaded zip to include file #{File.basename(path_to_expected_file)} but did not find it. Found #{downloaded_files.keys}."
    else
      actual = File.read(downloaded_file_path)
      expected = File.read(path_to_expected_file)
      normalise_xml(actual).should eq normalise_xml(expected)
    end
  end

end
def save_response_to_file(response_source)
  tempfile = Tempfile.new(["temp_file", ".zip"])
  tempfile.close
  file = File.open(tempfile.path, "wb")
  file.write(response_source)
  file.close

  file
end

def extract_returning_files_hash(zip)
  temp_dir = Dir.mktmpdir

  files = {}
  Zip::ZipFile.foreach(zip.path) do |file|
    path = File.join(temp_dir, file.name)
    file.extract(path)
    files[file.name] = path
  end

  files
end
