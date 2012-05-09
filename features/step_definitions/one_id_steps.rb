And /^I have oneid users$/ do |table|
  table.hashes.each do |attrs|
  end
end
Then /^I should (not )?see One ID results table$/ do |not_see, expected_table|
  selector = 'one_id_search_results'
  if not_see
    find_or_nil(selector).should be_nil
  else
    diff_tables!(expected_table, selector)
  end
end
