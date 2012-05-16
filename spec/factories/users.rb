def after_set(u)
  if u.is_ldap and u.login_attribute.nil?
    u.login_attribute = u.one_id
  elsif !u.is_ldap and u.login_attribute.nil?
    u.login_attribute = u.email
  end

  if u.is_ldap and u.one_id.nil?
    u.one_id = ''
  end
end
FactoryGirl.define do
  factory :user do
    first_name "Fred"
    last_name "Bloggs"
    password "Pas$w0rd"
    is_ldap false
    sequence(:email) { |n| "#{n}@intersect.org.au" }

    after_build {|u| after_set(u) }
  end
end
