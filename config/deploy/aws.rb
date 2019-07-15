raise ArgumentError, "Missing required environment variable, SSH_HOST." unless ENV['SSH_HOST']
raise ArgumentError, "Missing required environment variable, SSH_KEY." unless ENV['SSH_KEY']

server ENV['SSH_HOST'],
  user: 'ec2-user',
  roles: %w{web app db},
  ssh_options: {
    user: 'ec2-user',
    keys: [ENV['SSH_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
  }
