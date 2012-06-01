Then /^I should not see the One ID results table$/ do
  find_or_nil('#one_id_search_results').should be_nil
end

Then /^I should see One ID results table$/ do |expected_table|
  diff_tables!(expected_table, 'one_id_search_results')
end
And /^I press "Create" for One ID "(.*)"$/ do |one_id|
  find("#create_#{one_id}").click
end
And /^I login as one id user "(.*)" with password "(.*)"$/ do |one_id, password|
  visit path_to("the login page")
  fill_in("user_login_attribute", with: one_id)
  fill_in("user_password", with: password)
  click_button("Log in")
end
Then /^I should be at the one id change password page$/ do
  pending
  current_url.should eq APP_CONFIG['one_id_password_reset_url']
end
