And /^I should see buttons "(.*)" and not "(.*)"$/ do |buttons_to_see, buttons_not_to_see|
  buttons_to_see.split(', ').each do |button|
    page.should have_xpath("//input[@value='#{button}']")
  end

  buttons_not_to_see.split(', ').each do |button|
    page.should have_no_xpath("//input[@value='#{button}']")
  end
end

