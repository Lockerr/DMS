set :application, "crm"
set :repository,  "ssh://anton@192.168.1.71/home/anton/work/dms/"
set :domain, 'user@192.168.1.98'
set :password, 'ktghfpjhbq'
set :deploy_to, '/home/user/dms/'

set :deploy_via, :copy

set :scm, :git
set :scm_passphrase, 'werwerw'
set :scm_password, 'werwerw'
set :scm_username, 'anton'
set :use_sudo, true

role :web, domain
role :app, domain
role :db,  domain, :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do
    run 'bundle exec rails s -p 3001 -e production -d'
  end

  task :restart do
    run "if [ -f #{deploy_to}/shared/pids/server.pid ]; then kill -9 `cat #{deploy_to}/shared/pids/server.pid` && cd #{deploy_to}/current && /home/user/.rvm/rubies/ruby-1.9.2-p320/bin/ruby script/rails s -p 3001 -e production -d; else cd #{deploy_to}/current && /home/user/.rvm/rubies/ruby-1.9.2-p320/bin/ruby script/rails s -p 3001 -e production -d; fi"
  end
end


# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end