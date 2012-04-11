def find_papyrus_field(field_id)
  id = "#papyrus_#{field_id}"
  find(id)
end
def get_papyrus_field(field_id)
  find_papyrus_field(field_id).value
end
def set_papyrus_field(field_id, value)
  input = find_papyrus_field(field_id)
  if input.tag_name == 'select'
    select value, from: input[:id]
  else
    input.set value
  end
end
def papyrus_field_should_be_in_error(field_id)
  input = find_papyrus_field(field_id)
  classes = input.find(:xpath, '..')[:class].split(' ')
  classes.should include("field_with_errors")
end

When /^I enter the following papyrus details$/ do |table|
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    if field == 'Date'
      year, era = value.split ' '
      set_papyrus_field('date_year', year)
      set_papyrus_field('date_era', era) unless era.nil?
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
    display_value = find("#display_#{field_id}>div:last-child")
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
    visibility = attrs.delete 'visibility'

    year, era = date.split ' ' if date
    country = Country.find_by_name! country_of_origin if country_of_origin.present?

    papyrus = Papyrus.new(attrs)
    papyrus.date_year = year
    papyrus.date_era = era
    papyrus.country_of_origin = country
    if languages
      languages = languages.split ', ' if languages
      languages = languages.map { |name| Language.find_by_name! name }
      papyrus.languages = languages
    end
    papyrus.genre = Genre.find_by_name! genre if genre.present?

    papyrus.visibility = visibility

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

And /^I should see the following fields with errors$/ do |table|
  table.hashes.each do |row|
    field = row[:field]
    message = row[:message]
    if field == 'Date'
      date_year_field = find_papyrus_field(:date_year)
      date_era_field = find_papyrus_field(:date_era)
      year_message, era_message = message.split ';' 
      step "the \"#{date_year_field[:id]}\" field should have the error \"#{year_message}\""
      step "the \"#{date_era_field[:id]}\" field should have the error \"#{era_message}\""
    elsif field == 'Languages'
      language_field = find_papyrus_field(:languages)
      step "the \"#{language_field[:id]}\" field should have the error \"#{message}\""
    else
      a_field = find_papyrus_field(field.downcase.gsub(' ', '_'))
      step "the \"#{a_field[:id]}\" field should have the error \"#{message}\""
    end
  end
end

And /^"MQT ([^"]*)" should have a visibility of "([^"]*)"$/ do |mqt_number, visibility|
  papyrus = Papyrus.find_by_mqt_number! mqt_number
  papyrus.visibility.should eq visibility
end
And /^I should see the list papyri table$/ do |expected_table|
  diff_tables!(expected_table, 'papyri_table')
end

And /^I should (not )?see the pagination controls$/ do |not_see|
  if not_see
    page.should_not have_css('div.pagination')
  else
    page.should have_css('div.pagination')
  end
end

And /^I should not see the search results table$/ do

    page.should_not have_css('#search_results')

end

Then /^I should see search results "MQT ([^"]*)"$/ do |mqt_numbers|
  ids = mqt_numbers.split ", "
  papyri = Papyrus.order('mqt_number').where(mqt_number: ids)
  rows = papyri.map do |papyrus|
    [papyrus.formatted_mqt_number, papyrus.inventory_id, papyrus.note || '', papyrus.country_of_origin.try(:name) || '', papyrus.human_readable_has_translation]
  end
  expected_table = [
    ['MQT Number', 'Inventory ID', 'Note', 'Country of Origin', 'Translation'],
    *rows
  ]
  actual = find("table#search_results").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  expected_table.should eq actual
end

def diff_tables!(expected_table, actual_id)
  actual = find("table##{actual_id}").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  expected_table.diff!(actual)
end
