Given /^I have an access request for "MQT ([^"]*)" from "([^"]*)" at "([^"]*)"$/ do |mqt_number, username, date|
  papyrus = Papyrus.find_by_mqt_number(mqt_number)
  user = User.find_by_email(username)
  FactoryGirl.create(:access_request, user: user, papyrus: papyrus, date_requested: date)
end

Then /^I should see pending requests$/ do |expected_table|
  diff_tables!(expected_table, 'pending_requests')
end

Then /^I should see approved requests$/ do |expected_table|
  diff_tables!(expected_table, 'approved_requests')
end

Then /^I should see rejected requests$/ do |expected_table|
  diff_tables!(expected_table, 'rejected_requests')
end

Given /^I have papyrus access requests$/ do |table|
  table.hashes.each do |row|
    user = User.find_by_email!(row["User requesting access"])
    papyrus = Papyrus.find_by_mqt_number!(row["MQT Number"])
    status = AccessRequest::CREATED
    status = AccessRequest::APPROVED if row["Date approved"] && !row["Date approved"].blank?
    FactoryGirl.create(:access_request, user: user, papyrus: papyrus, date_requested: row["Date requested"], date_approved: row["Date approved"], status: status)
  end
end

When /^I approve the requests$/ do |table|
  table.hashes.each do |row|
    approval_date = Time.strptime(row["date_approved"], '%Y-%m-%d')
    Time.stub!(:now).and_return(approval_date)
    request = AccessRequest.find_by_user_id(User.find_by_email(row["user_requesting_access"]))
    request.approve!
  end
end
