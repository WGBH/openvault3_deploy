# Open Vault Code Deployment

This is the Capistrano project that deploys code and ingests records for
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
    chmod 600 ~/.ssh/xyz.wgbh-mla.org.pem
    ```

1. **Determine the IP address of the EC2 instance**

  Assuming your server was created with [aws-wrapper](https://github.com/WGBH/aws-wrapper),
  the DNS name you have does not point to the EC2 instance itself, but rather, to a
  load balancer in front of the the instance. To obtain the EC2 IP, you can look
  in the AWS console, or

  ```
  cd ../aws-wrapper
  ruby scripts/ssh_opt.rb --just_ips --name xyz.wgbh-mla.org
  ```

1. **Run `bundle install`**

  If `bundle install` runs successfully, then you should be able to run a deployment or ingest records.

## Deploy

From the root directory of your cloned repo, run the capistrano command for the `demo` stage. This step could take a few minutes.

```
bundle exec cap demo deploy OV_HOST=1.2.3.4 OV_SSH_KEY=~/.ssh/xyz.wgbh-mla.org.pem
```

If there were no errors, then you should be able to see the Open Vault website running in a web browser, at the target host's IP address.
If there were errors, or if you can't see the running website, then please [file a bug](https://github.com/WGBH/openvault3_deploy/issues).

## Ingest

To ingest into a server which is already up and running.

```
bundle exec cap demo ingest OV_HOST=1.2.3.4 OV_SSH_KEY=~/.ssh/xyz.wgbh-mla.org.pem OV_PBCORE=fm-export.zip
```

## Solr index

Normally, you won't have to worry about installing or uninstalling your Solr
instance. Running a deployment according to the steps above will setup a Solr
index for you (using
[`blacklight-jetty`](https://github.com/projectblacklight/blacklight-jetty)).

In special circumstances however, you may want to replace an existing Solr repository with a new one.

#### Remove your existing Solr index

**WARNING!** Doing this will delete your exisiting index and its data. This
operation cannot be undone. Normally you shouldn't have to do this.

```
bundle exec cap demo jetty:uninstall OV_HOST=1.2.3.4 OV_SSH_KEY=~/.ssh/xyz.wgbh-mla.org.pem
```

#### Install a new Solr index

This will install a new Solr index (if needed), configure it, and start it. It
is idempotent, and is run at the end of every deploy. Normally you shouldn't
have to do this, but you may if you removed your existing Solr index using the
steps above.

```
bundle exec cap demo jetty:install OV_HOST=1.2.3.4 OV_SSH_KEY=~/.ssh/xyz.wgbh-mla.org.pem
```


## TODO

error notification. issue #32.
