def set_papyrus_field(field_id, value)
	input = find("#papyrus_#{field_id}")
	input.set value
end

When /^I enter the following papyrus details$/ do |table|
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    if field != 'Date'
		  field_id = field.downcase.gsub ' ', '_'
		  set_papyrus_field(field_id, value)
		else
		  year, era = value.split ' '
		  set_papyrus_field('date_year', year)
		  set_papyrus_field('date_era', era)
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
