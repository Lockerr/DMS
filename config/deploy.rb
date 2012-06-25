set :application, "crm"
set :repository,  "ssh://anton@192.168.1.71/work/dms/"
set :domain, 'user:192.168.1.98'
set :user, 'user'
set :password, 'ktghfpjhbq'
set :deploy_to => '/home/dms'

set :deploy_via, :remote_cache

set :scm, :git
set :scm_passphrase, 'werwerw'
set :use_sudo => false

role :web, domain
role :app, domain
role :db,  domain, :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end