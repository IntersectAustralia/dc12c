def set_papyrus_field(field_id, value)
  id = "#papyrus_#{field_id}"
  input = find(id)
  if input.tag_name == 'select'
    select value, from: id.slice(1..-1)
  else
    input.set value
  end
end

When /^I enter the following papyrus details$/ do |table|
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    if field == 'Date'
      year, era = value.split ' '
      set_papyrus_field('date_year', year)
      set_papyrus_field('date_era', era)
    elsif field == 'Languages'
      languages = value.split(', ')
      languages.each do |l|
        language = Language.find_by_name! l
        field_id = "language_ids_#{language.id}"
        set_papyrus_field(field_id, 'checked')
      end
    else
      field_id = field.downcase.gsub ' ', '_'
      set_papyrus_field(field_id, value)
    end
  end
end
Then /^I should see the following papyrus details$/ do |table|
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    field_id = field.downcase.gsub ' ', '_'
    display_value = find("#display_#{field_id}>span:last-child")
    display_value.text.should eq value
  end
end
And /^I have languages$/ do |table|
  table.hashes.each do |attrs|
    Factory(:language, attrs)
  end
end
And /^I have genres$/ do |table|
  table.hashes.each do |attrs|
    Factory(:genre, attrs)
  end
end
And /^I have countries$/ do |table|
  table.hashes.each do |attrs|
    Factory(:country, attrs)
  end
end

