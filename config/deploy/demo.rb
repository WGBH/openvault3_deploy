server '54.88.162.203', # TODO parameterize host IP
  user: 'ec2-user',
  roles: %w{web app},
  ssh_options: {
    user: 'ec2-user',
    keys: %w(/Users/andrew_myers/.ssh/ansible-test.pem), # TODO parameterize key file name
    forward_agent: false,
    auth_methods: %w(publickey)
  }
