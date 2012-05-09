load 'deploy'
# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
#
# required environment variables
# PAPYRI_USER - user to ssh to the server
# PAPYRI_PASSWORD - password of PAPYRI_USER
require 'bundler/capistrano'

# Force a pseudo terminal if a password is required
default_run_options[:pty] = true

set :application,   'papyri'
#set :repository,    "http://github.com/IntersectAustralia/dc12c.git"
#set :branch,        'mq-deploy'

# deploy via copy doesn't seem to be working... it is still trying to do a checkout remotely
# This assumes the current checkout is up to date (which it will be if using the defined script in bamboo...
set :repository, '.'

set :use_sudo,      false

set :keep_releases, 5

set :scm,           'none'
set :deploy_to,     "/var/www/papyri"
set :deploy_via,    :copy
set :copy_exclude,  [".git/*"]

# scm_username/scm_password not necessary as it is a public repository

set :user, ENV.fetch('PAPYRI_USER')
set :password, ENV.fetch('PAPYRI_PASSWORD')

def missing_or_unknown_environment(env)
  raise "Unknown environment: #{env.inspect}.\nAvailable envs are [showcase, staging, production]"
end

set :rails_env, ENV['env'] ? ENV['env'] : nil
case rails_env
  when 'showcase'
    set :deploy_server, '10.123.32.40'
  when 'staging', 'production'
    # do nothing
  else
    missing_or_unknown_environment(rails_env)
end

# Set HTTP proxy so that "bundle install" can fetch gems from rubygems.org
default_environment['http_proxy'] = 'http://137.111.226.21:3128'
default_environment['HTTP_PROXY'] = 'http://137.111.226.21:3128'

# Set home path to the Oracle Full Client - used for compiling the ruby-oci8 gem
default_environment['ORACLE_HOME'] = '/ora/sw/product/11.2.0/dbhome_1'

# And now for the deployment roles and tasks

role :app, deploy_server
role :web, deploy_server
role :db,  deploy_server, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Set directory and file permission"
  task :set_runtime_permissions do
    run "find #{latest_release} -type d | xargs chmod a+rx"
    run "chmod -R o+rw #{latest_release}" # TODO: Does 'other' really, really need write permissions?
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after 'deploy:finalize_update', 'deploy:set_runtime_permissions'
after 'deploy:finalize_update' do
  deploy.set_runtime_permissions
  lines = capture ". /etc/profile; env | grep PAPYRI"
  kvs = lines.split("\n").map{|line| line.split '='}
  kvs.each do |key, value|
    default_environment[key] = value
  end
  run "cd #{release_path} && LANG=en_US.UTF-8 bundle install --verbose --deployment"
  run "sed -e's/#<Syck.*>/=/' -i /apps/papyri/releases/*/vendor/bundle/ruby/1.9.1/specifications/factory_girl_rails-3.1.0.gemspec" # broken gemspec hack
  run "cd #{release_path} && LANG=en_US.UTF-8 bundle install --verbose --deployment;"
  run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
end

#after 'deploy:update_code', 'deploy:migrate'
