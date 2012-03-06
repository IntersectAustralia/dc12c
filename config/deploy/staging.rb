# Your HTTP server, Apache/etc
role :web, 'demo_server'
# This may be the same as your Web server
role :app, 'demo_server'
# This is where Rails migrations will run
role :db,  'demo_server', :primary => true

