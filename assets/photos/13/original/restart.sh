#! /bin/bash

if [ -f /home/perekup/application/shared/pids/unicorn.pid ]; then kill -USR2 `cat /home/perekup/application/shared/pids/unicorn.pid`; else
cd /home/perekup/application/current && bundle exec unicorn_rails -c /home/perekup/application/current/config/unicorn.rb -E production -D

