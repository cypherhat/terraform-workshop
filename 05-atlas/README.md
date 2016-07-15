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
```

Similar to git push, this will send our remote state to Atlas. Atlas is now managing our remote state - this is most ideal for teams or using Atlas to run Terraform for you (which we will do now).

git checkout master && git pull && git checkout -b atlas-integration

terraform get -update

terraform push -vcs=false -name="$ATLAS_ENV" ./05-atlas

git push origin -u atlas-integration