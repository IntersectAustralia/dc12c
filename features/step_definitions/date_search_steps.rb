And /I fill in date search information "(.*)" "(.*)"/ do |date_from, date_to|
  fill_in_date_search(:from, date_from)
  fill_in_date_search(:to, date_to)
end

Then /I should see search errors "(.*)"/ do |error_messages|
  errors = error_messages.split(', ')

  error_box = find('#error_explanation')
  errors.each { |error| error_box.should have_content(error) }
end

Then /^I should see date search information "(.*)" "(.*)" "(.*)" "(.*)"$/ do |from_year, from_era, to_year, to_era|
  find("#date_from_year").value.should eq from_year
  find("#date_from_era").value.should eq from_era
  find("#date_to_year").value.should eq to_year
  find("#date_to_era").value.should eq to_era
end

def fill_in_date_search(from_or_to, date_string)
  if date_string =~ /(^\d+)/
    find("#date_#{from_or_to}_year").set($1)
  end
  if date_string =~ /(CE|BCE)$/
    select($1, from: "date_#{from_or_to}_era")
  end
end
