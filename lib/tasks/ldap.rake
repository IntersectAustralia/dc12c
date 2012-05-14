begin
  desc "run ldap server"
  task :run_ldap_server => :environment do
    ldap_config = YAML.load(ERB.new(File.read("#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    port = ldap_config['port']
    server = Ladle::Server.new(quiet: true, ldif: Rails.root.join('config', 'test_ldap_data.ldif').to_s, tmpdir: '/tmp', domain: 'dc=mqauth,dc=uni,dc=mq,dc=edu,dc=au', port: port)

    server.start
    puts "server started"

    begin
      sleep
    rescue Interrupt
      puts 'exiting'
      server.stop
    end
  end
rescue LoadError
  puts "It looks like some Gems are missing: please run bundle install"
end
