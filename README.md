# Open Vault Code Deployment

This is a a Capistrano project that deploys
[code for the Open Vault website](https://github.com/WGBH/openvault3), a
project maintained by WGBH Media Library and Archives.

This documentation is intended for use by WGBH-MLA staff. It is not expected to
to work for the general public.

## Prerequisites

Before deploying, ensure the following:
  * **The target host has been created, is running on AWS, and has been
    fully provisioned.** (Click [here](https://github.com/WGBH/mla-playbooks)
    for inforamtion on provisioning servers for Open Vault)
  * **You have the private key required to SSH into the host.**

## Setup your local copy of the deployment repository

1. **Clone the repository**
  ```
  git clone https://github.com/WGBH/openvault3_deploy.git
  cd openvault3_deploy
  ```

1. **Copy the sample stage file**

  ```
  cp config/deploy/demo.rb.sample config/deploy/demo.rb
  ```

1. **Get the private key for accessing the target host with SSH and set the permissions**

  The private key must be securely obtained from a WGBH-MLA developer. By
  convention, name the private key file the same as the name of the key pair
  in AWS, and put it in your `~/.ssh/` directory.

  For instance, if the key pair used to access the host is named "openvault-
  demo", then your private key file should be at `~/.ssh/openvault-demo.pem`.

  Set the permissions of the private key file to `600`, e.g.
    ```
    chmod 600 ~/.ssh/openvault-demo.pem
    ```

1. **Edit the stage file**

  The `config/deploy/demo.rb` needs to be edited to contain the actual target
  host, and the actual key file used to access that host.

  In the `config/deploy/demo.rb` file, replace `xxx.xxx.xxx.xxx` with the
  target host's public IP or domain, and replace `path/to/private-key.pem`
  with the actual path to your private key file.

  For instance, if the target
  host's IP is `123.123.123.123`, and your private key file is at `~/.ssh
  /openvault-demo.pem`, then your `config/deploy/demo.rb` file should look
  something like this:

    ```ruby
    server '123.123.123.123',
      user: 'ec2-user',
      roles: %w{web app},
      ssh_options: {
        user: 'ec2-user',
        keys: %w(~/.ssh/openvault-demo.pem),
        forward_agent: false,
        auth_methods: %w(publickey)
      }

    ```

1. **Run `bundle install`**

If `bundle install` runs successfully, then you should be able to run a deployment.

If something has gone wrong, please [file a bug](https://github.com/WGBH/openvault3_deploy/issues).

## Run the deployment

From the root directory of your cloned repo, run the capistrano command for the `demo` stage. This step could take a few minutes.

`bundle exec cap demo deploy`

If there were no errors, then you should be able to see the Open Vault website running in a web browser, at the target host's IP address.

If there were errors, or if you can't see the running website, then please [file a bug](https://github.com/WGBH/openvault3_deploy/issues).