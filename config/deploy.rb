set :application, "crm"
set :repository,  "git@github.com:Lockerr/DMS.git"
set :domain, 'user@192.168.1.98'
set :deploy_to, '/home/user/dms/'
# set :rvm_ruby_string, 'r328'
require "rvm/capistrano"

set :ssh_options, { :forward_agent => true }

set :deploy_via, :remote_cache

set :scm, :git
# set :scm_passphrase, 'werwerw'
# set :scm_password, 'werwerw'
# set :scm_username, 'anton'
set :use_sudo, true

role :web, domain
role :app, domain
role :db,  domain


after 'update_code', 'bundle install'
namespace :deploy do
  task :start do
    run "cd #{deploy_to}current && bundle exec rails s -p 3001 -e production -d"
  end

  task :restart do
    run "if [ -f #{deploy_to}shared/pids/server.pid ]; then kill -9 `cat #{deploy_to}shared/pids/server.pid` && cd #{deploy_to}current && bundle exec rails s -p 3001 -e production -d; else cd #{deploy_to}/current && bundle exec rails s -p 3001 -e production -d; fi"
  end
end




desc "tail production log files"
task :tail, :roles => :app do
  trap("INT") { puts 'Interupted'; exit 0; }
  run "tail -f #{deploy_to}shared/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

