
Then /^I should receive a zip file matching "([^"]*)"$/ do |directory|
  #saves the latest response, unzips it, then compares with a pre-defined directory of files that match what you expect the zip to contain
  compare_zip_to_expected_files(page.source, directory)
end

def compare_zip_to_expected_files(response_source, directory)
  zip = save_response_to_file(response_source)
  downloaded_files = extract_returning_files_hash(zip)

  expected_files = Dir.glob(File.join(Rails.root, directory, "/*"))

  downloaded_files.size.should eq(expected_files.size)
  expected_files.each do |path_to_expected_file|
    downloaded_file_path = downloaded_files[File.basename(path_to_expected_file)]
    if downloaded_file_path.nil?
      raise "Expected downloaded zip to include file #{File.basename(path_to_expected_file)} but did not find it. Found #{downloaded_files.keys}."
    else
      downloaded_file_path.should be_same_file_as(path_to_expected_file)
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
    downloaded_files[file.name] = path
  end

  files
end
