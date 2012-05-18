template = <<EOS
dn: CN=%{one_id},OU=Affiliated-Staff,OU=Active,OU=MQ-Users,DC=mqauth,DC=uni,DC=mq,DC=edu,DC=au
objectClass: top
objectClass: inetorgperson
cn: %{one_id}
uid: %{one_id}
sn: %{last_name}
l: Affiliated-Staff
title: Ms
description: %{first_name} %{last_name}
givenName: %{first_name}
userpassword: mypassword
mail: %{first_name}.%{last_name}@mq.edu.au
EOS

File.open('test_users.ldif', 'w') do |f|
  30.times do |i|
    args = {
      one_id: 1000000+i,
      last_name: "Last_#{i}",
      first_name: "First_#{i}"
    }
    f.puts(template % args)
    f.puts
  end
end
