When /^I enter the following papyrus details$/ do |table|
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    field_id = field.downcase.gsub ' ', '_'
    input = find("#papyrus_#{field_id}")
    input.set value
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
