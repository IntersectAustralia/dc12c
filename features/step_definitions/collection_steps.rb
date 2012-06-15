Given /^I have collections "([^"]*)" with description "([^"]*)"$/ do |arg1, arg2, table|
  table.hashes.each do |hash|
    title = hash.fetch 'title'
    description = hash.fetch 'description'
    mqts = hash.fetch('mqts').split(', ').map(&:to_i)
    papyri = Papyrus.where(mqt_number: mqts)
    FactoryGirl.create(:collection, title: title, description: description, papyri: papyri)
  end
end

Then /^I should see collections$/ do |expected_table|
  collections = all('#collections li')
  actual = collections.map do |elem|
    title = elem.find('a.title').text
    description = elem.find('.description').text
    {
      "title" => title,
      "description" => description
    }
  end
  actual.should eq expected_table.hashes
end

Then /^I should see collection$/ do |expected_table|
  hash = expected_table.hashes.first

  title = hash.fetch "title"
  description = hash.fetch "description"
  keywords = hash.fetch "description"

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
end
Given /^I fill in collection details$/ do |table|
  details = table.hashes.first.each do |field_name, value|
    if field_name == 'mqts'
      papyri = Papyrus.where(mqt_number: value.split(', ').map(&:to_i))
      papyri.each do |p|
        find("#collection_papyrus_ids_#{p.id}").set 'checked'
      end
    else
      find("#collection_#{field_name}").set value
    end
  end
end

When /^I follow edit for collection "([^"]*)"$/ do |title|
  c = Collection.find_by_title! title
  find("#edit_collection_#{c.id}").click
end
