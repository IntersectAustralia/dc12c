Given /^I have collections "([^"]*)" with description "([^"]*)"$/ do |arg1, arg2, table|
  table.hashes.each do |hash|
    title = hash.fetch 'title'
    description = hash.fetch 'description'
    keywords = hash.fetch 'keywords'
    mqts = hash.delete('mqts').split(', ').map(&:to_i)
    papyri = Papyrus.where(mqt_number: mqts)
    FactoryGirl.create(:collection, hash.merge(papyri: papyri))
  end
end

Then /^I should see collections$/ do |expected_table|
  collections = all('#collections li')
  actual = collections.map do |elem|
    title = elem.find('a.title').text
    description = elem.find('.description').text.gsub(/^(\n)/, "")
    {
      "title" => title,
      "description" => description
    }
  end
  actual.should eq expected_table.hashes
end

Then /^I should see collection$/ do |expected_table|
  hash = expected_table.hashes.first

  title = hash.fetch 'title'
  description = hash.fetch 'description'

  description = description.gsub("%LONG_TEXT%", get_long_text)

  keywords = hash.fetch 'keywords'
  spatial_coverage = hash.fetch 'spatial_coverage'
  temporal_coverage = hash.fetch 'temporal_coverage'

  mqts = hash.fetch("mqts").split(", ").map(&:to_i)
  papyri = Papyrus.where(mqt_number: mqts)

  rows = all('#collection_papyri tbody tr')
  actual = rows.map do |row|
    row.all('td').map(&:text)
  end

  expected = papyri.map do |p|
    [p.formatted_mqt_number, p.genre.try(:name) || '', p.origin_details || '', p.formatted_date || '', p.languages_csv, "\n"]
  end

  actual.should eq expected

  find('p.description').text.gsub(/^(\n)/, "").should eq description
  find('p.keywords').text.should eq keywords
  find('p.spatial_coverage').text.should eq spatial_coverage
  find('p.temporal_coverage').text.should eq temporal_coverage
end
Given /^I fill in collection details$/ do |table|
  details = table.hashes.first.each do |field_name, value|
    if field_name == 'mqts'
      papyri = Papyrus.where(mqt_number: value.split(', ').map(&:to_i))
      papyri.each do |p|
        find("#collection_papyrus_ids_#{p.id}").set 'checked'
      end
    elsif field_name == 'description'
      find("#collection_#{field_name}").set value.gsub("%LONG_TEXT%", get_long_text)
    else
      find("#collection_#{field_name}").set value
    end
  end
end

When /^I follow edit for collection "([^"]*)"$/ do |title|
  c = Collection.find_by_title! title
  find("#edit_collection_#{c.id}").click
end

def get_long_text
  (0..10000).map { |x| "Hello World! " }.join
end

And /^(?:|I )fill in description "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value.gsub("%LONG_TEXT%", get_long_text))
end