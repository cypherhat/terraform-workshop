Atlas Integration
=================
Up until this point, we have been running Terraform locally. This is great for a single developer, but tends to break down in large teams. Instead, it is recommended that you use Atlas for managing infrastructure. In addition to running Terraform for you, Atlas has built-in ACLs, secure variable storage, and UIs for visualizing infrastructure. Atlas is also able to integrate with GitHub to provide first-class provenance in the system.

Remote State Setup
------------------

In order to start using this with Atlas, you will need to setup your remote state with Atlas. If you are starting a new project, you could just use the GitHub integration. Since we have an existing project, we have to configure the remote state and push our current Terraform configurations to Atlas so that Atlas can manage our resources.

First, export you Atlas token as an environment variable. Terraform reads this environment variable to authenticate you with Atlas:
```
$ export ATLAS_TOKEN="$(cat terraform.tfvars | grep atlas_token | cut -d'=' -f2 | tr -d '"' | tr -d ' ')"
```

Next, grab the name of your environment:
```
$ export ATLAS_ENV="$(cat terraform.tfvars | grep atlas_environment | cut -d'=' -f2 | tr -d '"' | tr -d ' ')"
```

The way we send our state to Atlas is via the following commands. Similar to git, first we configure the remote:
```
$ terraform remote config -backend="atlas" -backend-config="name=$ATLAS_ENV"
```

This will configure the remote state. Now we need to push our copy to Atlas:
```
$ terraform remote push

$ terraform push -vcs=true -name="$ATLAS_ENV" ./02-instances-elb
```

Similar to git push, this will send our remote state to Atlas. Atlas is now managing our remote state - this is most ideal for teams or using Atlas to run Terraform for you (which we will do now).  The flag `vcs=true` is important to note. If true (default), then Terraform will detect if a VCS is in use, such as Git, and will only upload files that are committed to version control. If no version control system is detected, Terraform will upload all files in path (parameter to the command).

We now go into Atlas, select our environment and update the Integrations with our GitHub details:

GitHub repository: `cypherhat/terraform-workshop`
GitHub branch: (default branch)
Terraform directory: `02-instances-elb`

After we click Associate, we see that a Terraform plan is running.

The plan fails:

```
There are warnings and/or errors related to your configuration. Please
fix these before continuing.

Errors:

  * file: open keys/my_key.pub: no such file or directory in:

${file("${var.public_key_path}")}

Setup failed: failed refreshing state (exit 1)

```

We never added the public and private keys to VCS (for good reason, of course.) But our Terraform plan needs them. For the purposes of this exercise, we will add these keys to our repository to show Atlas/GitHub integration.

CI/CD
-----

Create a new branch for the changes to the infrastructure.

```
$ git checkout -b very-insecure-branch
```

Remove the `**/keys` setting from the `.gitignore` file.

```
$ git status
```

We should see, among other things, the keys directories:

```
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	.vagrant/
	01-aws-vpc/keys/
	02-instances-elb/keys/
	03-consul-haproxy/keys/
	04-route53-record/keys/
	keys/
```

Add the keys for `02-instances-elb`:
```
$ git add 02-instances-elb/keys
$ git commit -m "Add keys to repo - this is bad"
$ git push origin -u very-insecure-branch
```

Go to GitHub and create a new pull request for this branch. You will see Atlas run the plan for this ne pull request. Since the plan succeeds we feel confident that the pull request can be merged, so we do.We go into Atlas and apply the plan.

Fin
