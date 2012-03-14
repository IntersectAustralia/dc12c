def get_papyrus_field(field_id)
  id = "#papyrus_#{field_id}"
  input = find(id)
  input.value
end
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

And /^I have (a papyrus|papyri)$/ do |_, table|
  table.hashes.each do |attrs|
    languages = attrs.delete 'languages'
    date = attrs.delete 'date'
    country_of_origin = attrs.delete 'country_of_origin'
    genre = attrs.delete 'genre'

    year, era = date.split ' ' if date
    country = Country.find_by_name! country_of_origin if country_of_origin

    papyrus = Papyrus.new(attrs)
    papyrus.date_year = year
    papyrus.date_era = era
    papyrus.country_of_origin = country
    if languages
      languages = languages.split ', ' if languages
      languages = languages.map { |name| Language.find_by_name! name }
      papyrus.languages = languages
    end
    papyrus.genre = Genre.find_by_name! genre if genre

    papyrus.save!
  end
end

Then /^I should see papyrus fields displayed$/ do |table|
  table.hashes.each do |row|

    field = row[:field]
    value = row[:value]
    if field == 'Date'
      year, era = value.split ' '
      get_papyrus_field('date_year').should == year
      get_papyrus_field('date_era').should == era
    elsif field == 'Languages'
      checked_ids = page.all(:css, '.papyrus_language_checkbox').find_all{|e|e.checked?}.map{|e|e.value}.map(&:to_i)

      languages = value.split(', ')
      expected_ids = languages.map do |l|
        language = Language.find_by_name! l
        language.id
      end

      checked_ids.sort.should eq expected_ids.sort
    else
      case field
        when 'Country of Origin'
          value = Country.find_by_name!(value).id
        when 'Genre'
          value = Genre.find_by_name!(value).id
      end
      field_id = field.downcase.gsub ' ', '_'
      get_papyrus_field(field_id).should eq value.to_s
    end
  end
end
And /^"([^"]*)" should have a visibility of "([^"]*)"$/ do |inventory_id, visibility|
  papyrus = Papyrus.find_by_inventory_id! inventory_id
  papyrus.visibility.should eq visibility
end
And /^I should see the list papyri table$/ do |expected_table|
  actual = find("table#papyri_table").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  expected_table.diff!(actual)
end

And /^I should (not )?see the pagination controls$/ do |not_see|
  if not_see
    page.should_not have_css('div.pagination')
  else
    page.should have_css('div.pagination')
  end
end