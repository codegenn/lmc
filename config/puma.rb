threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count
port        ENV.fetch("PORT") { 3000 }
app_dir = File.expand_path("../..", __FILE__)
environment "production"

bind "unix:///var/www/lmc/shared/tmp/sockets/puma.sock"
pidfile '/var/www/lmc/shared/tmp/pids/puma.pid'
state_path '/var/www/lmc/apps/shared/tmp/pids/puma.state'
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

plugin :tmp_restart
