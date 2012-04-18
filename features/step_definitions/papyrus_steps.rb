def find_or_nil(selector)
  begin
    find(selector)
  rescue Capybara::ElementNotFound
    nil
  end
end

def find_papyrus_field(field_id)
  id = "#papyrus_#{field_id}"
  find(id)
end
def get_papyrus_field(field_id)
  find_papyrus_field(field_id).value.to_s
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
    case field
      when /Date (From|To)/
        from_or_to = $1.downcase
        year_name, era_name = "date_#{from_or_to}_year", "date_#{from_or_to}_era"

        if ['BCE', 'CE'].include? value
          set_papyrus_field(year_name, '')
          set_papyrus_field(era_name, value)
        else
          year, era = value.split ' '

          if value == ''
            set_papyrus_field(year_name, '')
            set_papyrus_field(era_name, '')
          else
            set_papyrus_field(year_name, year)
            if era.nil?
              set_papyrus_field(era_name, '')
            else
              set_papyrus_field(era_name, era)
            end
          end
        end
      when 'Languages'
        languages = value.split(', ')
        languages.each do |l|
          language = Language.find_by_name! l
          field_id = "language_ids_#{language.id}"
          set_papyrus_field(field_id, 'checked')
        end
      when 'P.Macq Number'
        volume_number, item_number = value.split ' '
        volume_number ||= ''
        item_number ||= ''
        set_papyrus_field('volume_number', volume_number)
        set_papyrus_field('item_number', item_number)
      else
        field_id = field.downcase.gsub ' ', '_'
        set_papyrus_field(field_id, value)
    end
  end
end

Then /^I should (not )?see the following papyrus details$/ do |not_see, table|
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    field_id = field.downcase.tr ' .', '_'
    display_field = find_or_nil("#display_#{field_id}>div:last-child")
    if not_see
      display_field.should_not be_displayed(field_id)
    else
      display_field.should display_a(value, field_id)
    end
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

And /^I have (a papyrus|papyri)$/ do |_, table|
  table.hashes.each do |attrs|
    languages = attrs.delete 'languages'
    date_from = attrs.delete 'date_from'
    date_to = attrs.delete 'date_to'
    genre = attrs.delete 'genre'
    visibility = attrs.delete 'visibility'
    mq_publication = attrs.delete 'mq_publication'

    papyrus = Papyrus.new(attrs)

    if date_from
      if date_from.ends_with? 'BCE'
        papyrus.date_from = -date_from.to_i
      else
        papyrus.date_from = date_from.to_i
      end
      if date_to
        if date_to.ends_with? 'BCE'
          papyrus.date_to = -date_to.to_i
        else
          papyrus.date_to = date_to.to_i
        end
      end
    end

    if mq_publication
      volume_number, item_number = mq_publication.split ' '
      papyrus.volume_number = volume_number
      papyrus.item_number = item_number
    end

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

Given /^I have papyri with visibility "([^"]*)" and a field filled with "([^"]*)" or "([^"]*)"$/ do |visibility, str_value, num_value, table|
  numeric_fields = {trismegistos_id: true, date_from:true}
  table.hashes.each do |attrs|
    mqt_number = attrs[:mqt_number]
    field_name = attrs[:populated_field]
    papyrus = Papyrus.new(mqt_number: mqt_number, inventory_id: mqt_number)
    if 'languages' == field_name
      language = Language.new(name: str_value)
      language.save!
      papyrus.languages = [language]
    elsif 'genre' == field_name
      genre = Genre.new(name: str_value)
      genre.save!
      papyrus.genre = genre
    else
      value = numeric_fields[field_name.to_sym] ? num_value : str_value
      papyrus.send((field_name + "=").to_sym,value)
    end
    papyrus.visibility = visibility
    papyrus.save!
  end
end

Then /^I should see papyrus fields displayed$/ do |table|
  table.hashes.each do |row|

    field = row[:field]
    value = row[:value]
    case field
      when /^Date (From|To)$/
        from_or_to = $1.downcase

        year_name, era_name = "date_#{from_or_to}_year", "date_#{from_or_to}_era"

        if value.present?
          year, era = value.split ' '
        else
          year = era = ''
        end

        get_papyrus_field(year_name).should == year
        get_papyrus_field(era_name).should == era
      when 'Languages'
        checked_ids = page.all(:css, '.papyrus_language_checkbox').find_all{|e|e.checked?}.map{|e|e.value}.map(&:to_i)

        languages = value.split(', ')
        expected_ids = languages.map do |l|
          language = Language.find_by_name! l
          language.id
        end

        checked_ids.sort.should eq expected_ids.sort
      when 'P.Macq Number'
        volume_number, item_number = value.split ' '
        get_papyrus_field('volume_number').should eq volume_number
        get_papyrus_field('item_number').should eq item_number
      else
        if field == 'Genre'
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
  papyri = Papyrus.order('inventory_id').where(mqt_number: ids)
  rows = papyri.map do |papyrus|
    [papyrus.formatted_mqt_number, papyrus.inventory_id, papyrus.lines_of_text || '', papyrus.human_readable_has_translation]
  end
  expected_table = [
    ['MQT Number', 'Inventory ID', 'Lines of Text', 'Translation'],
    *rows
  ]
  actual = find("table#search_results").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  actual.should eq expected_table
end

And /^Date should be empty$/ do
  find('#display_date>div').text.should eq ''
end

def diff_tables!(expected_table, actual_id)
  actual = find("table##{actual_id}").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  expected_table.diff!(actual)
end
