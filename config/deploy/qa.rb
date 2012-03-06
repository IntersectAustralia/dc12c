# Your HTTP server, Apache/etc
role :web, 'QA_server'
# This may be the same as your Web server
role :app, 'QA_server'
# This is where Rails migrations will run
role :db,  'QA_server', :primary => true

