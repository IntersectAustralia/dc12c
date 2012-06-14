Given /^I have a user "([^"]*)"$/ do |email|
  FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'A')
end

Given /^I have a locked user "([^"]*)"$/ do |email|
  FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'A', :locked_at => Time.now - 30.minute, :failed_attempts => 3)
end

Given /^I have a deactivated user "([^"]*)"$/ do |email|
  FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'D')
end

Given /^I have a rejected as spam user "([^"]*)"$/ do |email|
  FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'R')
end

Given /^I have a pending approval user "([^"]*)"$/ do |email|
  FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'U')
end

Given /^I have a user "([^"]*)" with an expired lock$/ do |email|
  FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'A', :locked_at => Time.now - 1.hour - 1.second, :failed_attempts => 3)
end

Given /^I have a user "([^"]*)" with role "([^"]*)"$/ do |email, role_name|
  user = FactoryGirl.create(:user, :login_attribute => email, :email => email, :password => "Pas$w0rd", :status => 'A')
  role = Role.where(:name => role_name).first
  role = Role.new.tap{|r|r.name = role_name}.tap{|r|r.save!} unless role
  user.role_id = role.id
  user.save!
end

Given /^I am logged in as "([^"]*)"$/ do |email|
  login(email)
end

Given /^I have no users$/ do
  User.delete_all
end

Then /^I should be able to log in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  logout
  visit path_to("the login page")
  fill_in("user_login_attribute", :with => email)
  fill_in("user_password", :with => password)
  click_button("Log in")
  page.should have_content('Logged in successfully.')
  current_path.should == path_to('the home page')
end

When /^I attempt to login with "([^"]*)" and "([^"]*)"$/ do |email, password|
  visit path_to("the login page")
  fill_in("user_login_attribute", :with => email)
  fill_in("user_password", :with => password)
  click_button("Log in")
end

Then /^the failed attempt count for "([^"]*)" should be "([^"]*)"$/ do |email, count|
  user = User.where(:email => email).first
  user.failed_attempts.should == count.to_i
end

And /^I request a reset for "([^"]*)"$/ do |email|
  visit path_to("the login page")
  click_link "Forgot your password?"
  fill_in "Email", :with => email
  click_button "Send me reset password instructions"
end

Given /^I logout$/ do
  logout
end

def login(email)
  visit path_to("the login page")
  fill_in("user_login_attribute", :with => email)
  fill_in("user_password", :with => "Pas$w0rd")
  click_button("Log in")
end

def logout
  visit destroy_user_session_path
end
