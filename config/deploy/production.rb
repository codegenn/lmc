role :app, %w{dev-release@13.250.105.130}
role :web, %w{dev-release@13.250.105.130}
role :db,  %w{dev-release@13.250.105.130}

# Define server(s)

server '13.250.105.130', user: 'dev-release', roles: %w{web}
set :ssh_options, {
  forward_agent: false,
  auth_methods: %w(password),
  password: '123123',
  user: 'dev-release',
}