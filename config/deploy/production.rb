set :stage, :production
set :rails_env, :production
set :branch, "dev-move-server"
set :deploy_to, "/var/www/lmc"
server "3.0.100.94", user: "ubuntu", roles: %w{app db web}
