Given /^I have an access request for "([^"]*)" from "([^"]*)"$/ do |papyrus_name, username|
  papyrus = Papyrus.find_by_inventory_id(papyrus_name)
  user = User.find_by_email(username)
  AccessRequest.place_request(user, papyrus)
end