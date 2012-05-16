class LdapSearcher

  @@config = nil

  def self.search(opts={})
    # accepts one_id, first_name, last_name, excluded_one_ids as params
    # returns list of hashes containing one_id, first_name, last_name, email
    opts.reverse_merge! one_id: nil, first_name: nil, last_name: nil, excluded_one_ids: []
    raise 'no search terms provided' unless opts.any? { |k, v| v.present? }

    ous = %w(Staff Affiliated-Staff Students)
    search_results = ous.map do |ou|
      ldapsearch("OU=#{ou},#{config['base']}", opts)
    end
    search_results.flatten!
    search_results.map! do |entry|
      {
        first_name: entry['givenname'].first,
        last_name: entry[:sn].first,
        one_id: entry[config['one_id_key']].first,
        dn: entry[:dn].first,
        email: entry[:mail].first
      }
    end
    search_results.select! {|hash| hash[:last_name] && hash[:first_name] && hash[:email] && hash[:one_id] }
    search_results.reject! {|hash| opts[:excluded_one_ids].include? hash[:one_id] }
    search_results.sort_by {|hash| "#{hash[:last_name]} #{hash[:first_name]}" }
  end

  private

  def self.ldapsearch(base, opts)
    ldap = Net::LDAP.new(config)
    ldap.host = config['host']
    ldap.port = config['port']
    ldap.encryption = :simple_tls if config['ssl']

    ldap.open do |ldap|
      ldap.search(filter: filter(opts), base: base)
    end
  end

  def self.filter(opts)
    givenName = opts[:first_name]
    sn = opts[:last_name]
    one_id = opts[:one_id]

    filters = []
    filters << Net::LDAP::Filter.contains('givenName', givenName) if givenName.present?
    filters << Net::LDAP::Filter.contains('sn', sn) if sn.present?
    filters << Net::LDAP::Filter.eq(config['one_id_key'], one_id) if one_id.present?
    filters.reduce { |a, b| a & b }
  end

  def self.config
    if @@config.nil?
      @@config = YAML.load(ERB.new(File.read("#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    end
    @@config
  end

end
