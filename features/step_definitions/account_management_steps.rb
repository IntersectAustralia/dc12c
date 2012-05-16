Given /^I have access requests$/ do |table|
  table.hashes.each do |hash|
    if hash['email'] and not hash['login_attribute']
      hash['login_attribute'] = hash['email']
    end
    FactoryGirl.create(:user, hash.merge(:status => 'U'))
  end
end

Given /^I have (ldap )?users$/ do |ldap, table|
  table.hashes.each do |hash|
    hash['is_ldap'] = true if ldap
    FactoryGirl.create(:user, hash.merge(:status => 'A'))
  end
end

Given /^I have roles$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:role, hash)
  end
end

And /^I have role "([^"]*)"$/ do |name|
  FactoryGirl.create(:role, :name => name)
end

Given /^"([^"]*)" has role "([^"]*)"$/ do |email, role|
  user = User.where(:email => email).first 
  role = Role.where(:name => role).first
  user.role = role
  user.save!(:validate => false)
end

When /^I follow "Approve" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("approve_#{user.id}")
end

When /^I follow "Reject" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("reject_#{user.id}")
end

When /^I follow "Reject as Spam" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("reject_as_spam_#{user.id}")
end

When /^I follow "View Details" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("view_#{user.id}")
end

When /^I follow "Edit role" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("edit_role_#{user.id}")
end

Given /^"([^"]*)" is deactivated$/ do |email|
  user = User.where(:email => email).first
  user.deactivate
end

Given /^"([^"]*)" is pending approval$/ do |email|
  user = User.where(:email => email).first
  user.status = "U"
  user.save!
end

Given /^"([^"]*)" is rejected as spam$/ do |email|
  user = User.where(:email => email).first
  user.reject_access_request
end

Then /^"(.*)" should be a "(.*)"$/ do |email, role|
  User.find_by_email!(email).role.name.should eq role
end
