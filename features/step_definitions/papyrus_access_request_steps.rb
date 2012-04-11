Given /^I have an access request for "MQT ([^"]*)" from "([^"]*)"$/ do |mqt_number, username|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  user = User.find_by_email(username)
  AccessRequest.place_request(user, papyrus)
end
