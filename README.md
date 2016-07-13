Note: This project was initially forked from https://github.com/sethvargo/terraform-workshop-atlas.git.

Initial Infrastructure
======================
This training runs in a virtual machine driven by Vagrant. Start the VM by
running:

    $ vagrant up

And then establish a shell to the machine by running:

    $ vagrant ssh

Change directory into the `/vagrant` directory to get started:

    $ cd /vagrant

Variables
---------
There are a number of ways to set variables in Terraform including environment
variables, special environment variables, via the command line, and via a
tfvars file. For the purposes of this training, we will use a tfvars file,
however, it is recommended that you only use this method if you are comfortable
having plain-text secrets stored with your repository. For more information on
the different types of variables, please see the Terraform documentation.

I don't put anything in the `terraform.tfvars` file that shouldn't be (inadvertently)
checked into git. For these exercises, that means add the following to your `.profile`:

```
export TF_VAR_aws_access_key="REPLACE WITH YOUR ACCESS KEY"
export TF_VAR_aws_secret_key="REPLACE WITH YOUR SECRET KEY"
```

(Make sure to source your `.profile`.)

Open the `terraform.tfvars` file located in the root of this repository and
complete all fields.  The resulting file should look something like this:

```
aws_route53_zone_id = "REPLACE WITH YOUR AWS ROUTE53 ZONE"
domain_name         = "REPLACE WITH YOUR DOMAIN NAME"
ssh_allowed_ip      = "REPLACE WITH YOUR CIDR BLOCK"

```

Replace the above variables.

Environment Name
----------------
Since you might be sharing an AWS account, the best practice is to distinguish the resources you are creating from those created by others. I haven't figured out a way to do this with Terraform templates or variables yet, so, I do this with a script: `set_env`. To change your environment from `environment_name` to a name of your choosing, execute the `set_env` script:

```
./set_env cypherhat_env
```

This will change the environment name from `environment_name` to your `cypherhat_env`.

SSH keys
--------
In the first exercise, we will generate the SSH keys that will be used for all exercises.
These keys should not be checked into git. To generate the keys, execute the
`generate-keypair` script.
