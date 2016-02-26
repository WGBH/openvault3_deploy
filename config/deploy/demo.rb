raise ArgumentError, "Missing required environment variable, OV_HOST." unless ENV['OV_HOST']
raise ArgumentError, "Missing required environment variable, OV_SSH_KEY." unless ENV['OV_SSH_KEY']

server ENV['OV_HOST'],
  user: 'ec2-user',
  roles: %w{web app db},
  ssh_options: {
    user: 'ec2-user',
    keys: [ENV['OV_SSH_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
  }
