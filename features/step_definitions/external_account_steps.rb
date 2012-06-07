When /^I fill in external user info$/ do |table|
  table.hashes.first.each do |field_name, value|
    if field_name == 'role'
      save_and_open_page
      select value, from: 'user_role_id'
    else
      find("#user_#{field_name}").set value
    end
  end
end

When /^I sign in with the credentials in the email$/ do
  email_body = current_email.default_part_body.to_s

  lines = email_body.split("\n")
  login = nil
  password = nil
  lines.map do |line|
    if line =~ /<p>Login: (.*)<\/p>/
      login = $1
    elsif line =~ /<p>Password: (.*)<\/p>/
      password = $1
    end
  end
  #raise "#{email_body.inspect}\n'#{login.inspect}'\n'#{password.inspect}'"

  if login.nil? or password.nil?
    raise "login: #{login.inspect} password: #{password.inspect}\ncouldn't find login/password in:\n#{email_body}"
  end

  logout # from login_steps.rb
  login_with(login, password)
end

def login_with(login, password)
  #raise User.find_by_login_attribute(login).inspect
  visit path_to("the login page")
  fill_in("user_login_attribute", with: login)
  fill_in("user_password", with: password)
  click_button("Log in")
end
