And /I fill in date search information "(.*)" "(.*)"/ do |date_from, date_to|
  fill_in_date_search(:from, date_from)
  fill_in_date_search(:to, date_to)
end

Then /I should see search errors "(.*)"/ do |error_messages|
  errors = error_messages.split(', ')

  error_box = find('#error_explanation')
  errors.each { |error| error_box.should have_content(error) }
end

def fill_in_date_search(from_or_to, date_string)
  if date_string =~ /(^\d+)/
    fill_in("date_#{from_or_to}_year", :with => $1.to_i)
  end
  if date_string =~ /(CE|BCE)$/
    select($1, from: "date_#{from_or_to}_era")
  end
end
