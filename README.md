# Open Vault Code Deployment

This is the Capistrano project which deploys code and ingests records for
[Open Vault](https://github.com/WGBH/openvault3),
a website maintained by WGBH Media Library and Archives.

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

1. **Get the private key for accessing the target host with SSH and set the permissions**

  The private key must be securely obtained from a WGBH-MLA developer. By
  convention, the name will correspond to a set of AWS resources, in particular
  an AWS keypair. Keep the private key in your `~/.ssh/` directory, with 
  permissions set appropriately:

    ```
    chmod 600 ~/.ssh/xyz.wgbh-mla-test.org.pem
    ```

1. **Determine the IP address of the EC2 instance**

  Assuming your server was created with [aws-wrapper](https://github.com/WGBH/aws-wrapper),
  the DNS name you have does not point to the EC2 instance itself, but rather, to a
  load balancer in front of the the instance. To obtain the EC2 IP, you can look
  in the AWS console, or

  ```
  cd ../aws-wrapper
  ruby scripts/ssh_opt.rb --just_ips --name xyz.wgbh-mla-test.org
  ```

1. **Run `bundle install`**

  If `bundle install` runs successfully, then you should be able to run a deployment or ingest records.

## Deploy

From the root directory of your cloned repo, run the capistrano command for the `demo` stage. This step could take a few minutes.

```
OV_HOST=1.2.3.4 OV_SSH_KEY=~/.ssh/xyz.wgbh-mla-test.org.pem bundle exec cap demo deploy # TODO: confirm
```

If there were no errors, then you should be able to see the Open Vault website running in a web browser, at the target host's IP address.
If there were errors, or if you can't see the running website, then please [file a bug](https://github.com/WGBH/openvault3_deploy/issues).


## Ingest

You can also ingest into a server which is already up and running.

```
OV_HOST=1.2.3.4 OV_SSH_KEY=~/.ssh/xyz.wgbh-mla-test.org.pem OV_PBCORE=fm-export.zip bundle exec cap demo ingest:run
```


TODO: error notification. issue #32.
