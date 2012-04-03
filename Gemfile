source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'ruby-oci8', '~> 2.1.0'
gem 'activerecord-oracle_enhanced-adapter', '~> 1.4.1'

gem 'will_paginate'
gem 'squeel'
gem 'unicode_utils'
gem 'paperclip'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
    
gem "therubyracer" # TODO should this be in group :assets ?
group :development, :test, :jenkins do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "ruby-ldapserver", '~> 0.4.0', :git => 'http://github.com/IntersectAustralia/ruby-ldapserver.git'
  gem "net-ldap"

  # cucumber gems
  gem "cucumber"
  gem "capybara"
  gem "database_cleaner"
  #gem "spork"
  gem "launchy"    # So you can do Then show me the page
end

group :test, :jenkins do
  gem "cucumber-rails", require: false
  gem "shoulda"
end

gem "haml"
gem "haml-rails"
gem "tabs_on_rails"
gem "devise"
gem "email_spec", :groups => [:test, :jenkins]
gem "cancan"
gem "capistrano-ext"
gem "capistrano"
gem "capistrano_colors"
gem "metrical"
gem "simplecov", ">=0.3.8", :require => false, :groups => [:test, :jenkins]
gem 'colorize'
