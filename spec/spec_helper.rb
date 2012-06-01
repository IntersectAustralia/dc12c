require 'simplecov'
require 'paperclip/matchers'
SimpleCov.start 'rails'
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end
class Warden::SessionSerializer
  def serialize(record)
    record
  end

  def deserialize(keys)
    keys
  end
end

def make_ldap_server
  # TODO this code is not DRY, copied from features/support/env.rb
  ldap_config = YAML.load(ERB.new(File.read("#{Rails.root}/config/ldap.yml")).result)[Rails.env]
  port = ldap_config['port']
  Ladle::Server.new(quiet: true, ldif: Rails.root.join('config', 'test_ldap_data.ldif').to_s, tmpdir: '/tmp', domain: 'dc=mqauth,dc=uni,dc=mq,dc=edu,dc=au', port: port)
end

# adapted/from http://drawohara.com/post/89110816/ruby-comparing-xml
require 'rexml/document'

def normalise_xml(a)
  a = REXML::Document.new(a.to_s)

  normalized = Class.new(REXML::Formatters::Pretty) do
    def write_text(node, output)
      super(node.to_s.strip, output)
    end
  end

  normalized.new(indentation=0,ie_hack=false).write(node=a, a_normalized='')

  a_normalized
end
