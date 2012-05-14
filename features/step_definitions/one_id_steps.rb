And /^I have oneid users$/ do |table|
  table.hashes.each do |attrs|
  end
end

Then /^I should not see the One ID results table$/ do
  find_or_nil('one_id_search_results').should be_nil
end

Then /^I should see One ID results table$/ do |expected_table|
  diff_tables!(expected_table, 'one_id_search_results')
end
And /^I press "Create" for One ID "(.*)"$/ do |one_id|
  find("#create_#{one_id}").click
end
