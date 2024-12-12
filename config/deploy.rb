# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, 'lmc'

# Define where can Capistrano access the source repository

# set :repo_url, 'https://github.com/[user name]/[application name].git'

set :scm, :git
set :repo_url, 'git@github.com:codegenn/lmc.git'

# Define where to put your application code

set :deploy_to, "/var/www/lmc"

set :pty, true

set :format, :pretty
